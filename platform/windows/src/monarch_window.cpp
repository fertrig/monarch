#include "monarch_window.h"

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <flutter/dart_project.h>

#include "string_utils.h"
#include "monarch_state.h"

MonarchWindow::MonarchWindow(
	const flutter::DartProject& project,
	WindowManager* windowManager_)
	: FlutterWindow(project), windowManager(windowManager_)
{
}

MonarchWindow::~MonarchWindow()
{
}

void MonarchWindow::setTitle(std::string title)
{
	/*auto wtitle = to_wstring(title);
	SetWindowText(GetHandle(), &title[0]);*/
	SetWindowText(GetHandle(), L"TODO");
}

WindowInfo MonarchWindow::getWindowInfo()
{
	return WindowInfo(
		WindowHelper::getTopLeftPoint(GetHandle()),
		WindowHelper::getWindowSize(GetHandle()));
}

void MonarchWindow::move(int X, int Y, int nWidth, int nHeight)
{
	isMovingProgrammatically = true;
	MoveWindow(
		GetHandle(),
		X, Y,
		nWidth, nHeight,
		TRUE);
	isMovingProgrammatically = false;
}

ControllerWindow::ControllerWindow(
	const flutter::DartProject& project,
	WindowManager* windowManager)
	: MonarchWindow(project, windowManager)
{
	_previewWindowHandle = nullptr;
}

ControllerWindow::~ControllerWindow()
{
}

void ControllerWindow::init(HWND previewHwnd)
{
	_previewWindowHandle = previewHwnd;
}

LRESULT ControllerWindow::MessageHandler(
	HWND hwnd, 
	UINT const message, 
	WPARAM const wparam, 
	LPARAM const lparam) noexcept
{
	switch (message) {
	case WM_MOVE:
		if (_didInit() && !isMovingProgrammatically) {
			_postMoveMessage();
		}
		break;

	case WM_SIZE:
		if (_didInit()) {
			_postMoveMessage();
		}
		break;

	case WM_M_PREVMOVE:
		if (_didInit()) {
			WindowInfo* previewWindowInfo = (WindowInfo*)wparam;
			auto point = _getTopLeft(
				WindowInfo(previewWindowInfo->topLeft, previewWindowInfo->size),
				windowManager->selectedDockSide);
			auto size = getWindowInfo().size;

			move(point.x, point.y, size.width, size.height);

			delete previewWindowInfo;
		}
		break;

	}
	return MonarchWindow::MessageHandler(hwnd, message, wparam, lparam);
}

Point_ ControllerWindow::_getTopLeft(WindowInfo previewWindowInfo, DockSide side)
{
	auto controllerWindowInfo = getWindowInfo();
	switch (side)
	{
	case DockSide::right:
		return WindowHelper::getLeftWindowTopLeft(controllerWindowInfo, previewWindowInfo);
	case DockSide::left:
		return WindowHelper::getRightWindowTopLeft(previewWindowInfo);
	case DockSide::undock:
		return WindowHelper::getTopLeftPoint(GetHandle());
	default:
		throw std::runtime_error{ "DockSide not valid" };
	}
}

bool ControllerWindow::_didInit()
{
	return _previewWindowHandle != nullptr;
}

void ControllerWindow::_postMoveMessage()
{
	WindowInfo* windowInfo = new WindowInfo(getWindowInfo());
	::PostMessage(_previewWindowHandle, WM_M_CONTMOVE, WPARAM(windowInfo), 0);
}

PreviewWindow::PreviewWindow(
	const flutter::DartProject& project,
	WindowManager* windowManager,
	HWND controllerHwnd)
	: MonarchWindow(project, windowManager)
{
	_controllerWindowHandle = controllerHwnd;
}

PreviewWindow::~PreviewWindow()
{
}

void PreviewWindow::resize(
	Size_ deviceSize, 
	double scale, 
	DockSide dockSide, 
	WindowInfo controllerWindowInfo)
{
	auto deviceWidth = deviceSize.width;
	auto deviceHeight = deviceSize.height;
	auto scaledWidth = WindowHelper::scale((int)deviceWidth, scale);
	auto scaledHeight = WindowHelper::scale((int)deviceHeight, scale);

	Size_ size((long)scaledWidth, (long)scaledHeight);
	resizeDpiAware(size, dockSide, controllerWindowInfo);
	resizeUsingClientRectOffset(size, dockSide, controllerWindowInfo);
	_move(dockSide, controllerWindowInfo);
}

void PreviewWindow::undock()
{
	unsigned int offset = 24;
	auto point = WindowHelper::getTopLeftPoint(GetHandle());
	auto size = WindowHelper::getWindowSize(GetHandle());

	move(
		point.x + offset, 
		point.y + offset,
		size.width, 
		size.height);
}

void PreviewWindow::resizeDpiAware(
	const Size_ size, 
	DockSide dockSide, 
	WindowInfo controllerWindowInfo)
{
	auto target_point = _getTopLeft(controllerWindowInfo, dockSide);
	double scale_factor = WindowHelper::getDpiScaleFactor(GetHandle());

	//Logger _logger{ L"FlutterWindowHelpers.resizeDpiAware" };
	//_logger.shout(L"scale_factor: " + std::to_wstring(scale_factor));

	move(
		target_point.x, 
		target_point.y,
		WindowHelper::scale(size.width, scale_factor), 
		WindowHelper::scale(size.height, scale_factor));
}

void PreviewWindow::resizeUsingClientRectOffset(
	const Size_ size, 
	DockSide dockSide, 
	WindowInfo controllerWindowInfo)
{
	RECT clientFrame;
	GetClientRect(GetHandle(), &clientFrame);

	double scale_factor = WindowHelper::getDpiScaleFactor(GetHandle());

	clientFrame.right = WindowHelper::convert(clientFrame.right, scale_factor);
	clientFrame.bottom = WindowHelper::convert(clientFrame.bottom, scale_factor);

	//Logger _logger{ L"FlutterWindowHelpers.resizeOffsetDpiAware" };
	//_logger.shout(L"size: " + std::to_wstring(size.width) + L"x" + std::to_wstring(size.height));
	//_logger.shout(L"client: " + std::to_wstring(clientFrame.right) + L"x" + std::to_wstring(clientFrame.bottom));

	//auto offset = size.width - (int)clientFrame.right;
	Size_ offset(
		size.width - (int)clientFrame.right,
		size.height - (int)clientFrame.bottom);
	Size_ sizePlusOffset(
		size.width + offset.width,
		size.height + offset.height);

	resizeDpiAware(sizePlusOffset, dockSide, controllerWindowInfo);
}

void PreviewWindow::disableResizeMinimize()
{
	SetWindowLong(
		GetHandle(),
		GWL_STYLE,
		GetWindowLong(GetHandle(), GWL_STYLE) & ~WS_SIZEBOX & ~WS_MAXIMIZEBOX);
}

LRESULT PreviewWindow::MessageHandler(
	HWND hwnd,
	UINT const message, 
	WPARAM const wparam, 
	LPARAM const lparam) noexcept
{
	switch (message) {
	case WM_M_STATECHANGE:
	{		
		WindowInfo* controllerWindowInfo = (WindowInfo*)wparam;
		MonarchState* state = (MonarchState*)lparam;

		Size_ deviceSize(
			(int)state->device.logicalResolution.width, 
			(int)state->device.logicalResolution.height);

		resize(deviceSize, state->scale.scale, state->dock,
			WindowInfo(controllerWindowInfo->topLeft, controllerWindowInfo->size));

		delete controllerWindowInfo;
		delete state;
	}
	break;

	case WM_M_FLUTITLE:
	{
		std::string* title = (std::string*)lparam;

		setTitle(*title);

		delete title;
	}
	break;

	case WM_M_CONTMOVE:
	{
		WindowInfo* controllerWindowInfo = (WindowInfo*)wparam;

		_move(windowManager->selectedDockSide,
			WindowInfo(controllerWindowInfo->topLeft, controllerWindowInfo->size));

		delete controllerWindowInfo;
	}
	break;

	case WM_M_UNDOCK:
		undock();
		break;

	case WM_MOVE:
		// NEXT, CONFIRM: not sure about the isFlutterWindowReady here, the 
		// !isMovingProgrammatically guard should be enough, while the windows are launching
		// any resize change calls move, which uses the isMovingProgrammatically flag
		//if (MonarchChannelMethodsReceiver::isFlutterWindowReady && !isMovingProgrammatically) {
		if (!isMovingProgrammatically) {
			WindowInfo* windowInfo = new WindowInfo(getWindowInfo());
			PostMessage(_controllerWindowHandle, WM_M_PREVMOVE, WPARAM(windowInfo), 0);
		}
		break;
	}

	return MonarchWindow::MessageHandler(hwnd, message, wparam, lparam);
}

void PreviewWindow::_move(DockSide side, WindowInfo controllerWindowInfo)
{
	auto point = _getTopLeft(controllerWindowInfo, side);
	auto size = getWindowInfo().size;

	move(
		point.x, 
		point.y,
		size.width, 
		size.height);
}

Point_ PreviewWindow::_getTopLeft(WindowInfo controllerWindowInfo, DockSide side)
{
	auto previewWindowInfo = getWindowInfo();
	switch (side)
	{
	case DockSide::right:
		return WindowHelper::getRightWindowTopLeft(controllerWindowInfo);
	case DockSide::left:
		return WindowHelper::getLeftWindowTopLeft(previewWindowInfo, controllerWindowInfo);
	case DockSide::undock:
		return WindowHelper::getTopLeftPoint(GetHandle());
	default:
		throw std::runtime_error{ "DockSide not valid" };
	}
}
