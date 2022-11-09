// Mocks generated by Mockito 5.1.0 from annotations
// in monarch_cli/test/monarch_ui_fetcher_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:monarch_cli/src/utils/managed_process.dart' as _i9;
import 'package:monarch_cli/src/version_api/notification.dart' as _i8;
import 'package:monarch_cli/src/version_api/ui_bundle.dart' as _i5;
import 'package:monarch_cli/src/version_api/upgrade_info.dart' as _i4;
import 'package:monarch_cli/src/version_api/version.dart' as _i3;
import 'package:monarch_cli/src/version_api/version_api.dart' as _i6;
import 'package:monarch_utils/log.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeLogger_0 extends _i1.Fake implements _i2.Logger {}

class _FakeVersion_1 extends _i1.Fake implements _i3.Version {}

class _FakeUpgradeInfo_2 extends _i1.Fake implements _i4.UpgradeInfo {}

class _FakeUiBundle_3 extends _i1.Fake implements _i5.UiBundle {}

/// A class which mocks [VersionApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockVersionApi extends _i1.Mock implements _i6.VersionApi {
  MockVersionApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get readUserId =>
      (super.noSuchMethod(Invocation.getter(#readUserId), returnValue: '')
          as String);
  @override
  _i2.Logger get log =>
      (super.noSuchMethod(Invocation.getter(#log), returnValue: _FakeLogger_0())
          as _i2.Logger);
  @override
  String get prefix =>
      (super.noSuchMethod(Invocation.getter(#prefix), returnValue: '')
          as String);
  @override
  _i7.Future<_i3.Version> getLatestVersion(String? operatingSystem) => (super
          .noSuchMethod(Invocation.method(#getLatestVersion, [operatingSystem]),
              returnValue: Future<_i3.Version>.value(_FakeVersion_1()))
      as _i7.Future<_i3.Version>);
  @override
  _i7.Future<_i4.UpgradeInfo> getUpgradeInfo(
          String? operatingSystem, String? versionNumber) =>
      (super.noSuchMethod(
          Invocation.method(#getUpgradeInfo, [operatingSystem, versionNumber]),
          returnValue:
              Future<_i4.UpgradeInfo>.value(_FakeUpgradeInfo_2())) as _i7
          .Future<_i4.UpgradeInfo>);
  @override
  _i7.Future<_i5.UiBundle> getUiBundle(
          {String? operatingSystem,
          String? versionNumber,
          String? flutterVersion,
          String? flutterChannel}) =>
      (super.noSuchMethod(
              Invocation.method(#getUiBundle, [], {
                #operatingSystem: operatingSystem,
                #versionNumber: versionNumber,
                #flutterVersion: flutterVersion,
                #flutterChannel: flutterChannel
              }),
              returnValue: Future<_i5.UiBundle>.value(_FakeUiBundle_3()))
          as _i7.Future<_i5.UiBundle>);
  @override
  _i7.Future<List<_i8.Notification>> getNotifications(
          Map<String, dynamic>? contextInfoJson) =>
      (super.noSuchMethod(
              Invocation.method(#getNotifications, [contextInfoJson]),
              returnValue:
                  Future<List<_i8.Notification>>.value(<_i8.Notification>[]))
          as _i7.Future<List<_i8.Notification>>);
  @override
  _i7.Future<_i3.Version> getVersionForUpgrade(
          Map<String, dynamic>? contextInfoJson) =>
      (super.noSuchMethod(
              Invocation.method(#getVersionForUpgrade, [contextInfoJson]),
              returnValue: Future<_i3.Version>.value(_FakeVersion_1()))
          as _i7.Future<_i3.Version>);
  @override
  void logInfo(Object? object) =>
      super.noSuchMethod(Invocation.method(#logInfo, [object]),
          returnValueForMissingStub: null);
  @override
  void logWarning(Object? object, [dynamic e]) =>
      super.noSuchMethod(Invocation.method(#logWarning, [object, e]),
          returnValueForMissingStub: null);
  @override
  void logError(Object? object) =>
      super.noSuchMethod(Invocation.method(#logError, [object]),
          returnValueForMissingStub: null);
  @override
  void logException(Object? object, dynamic e, StackTrace? s) =>
      super.noSuchMethod(Invocation.method(#logException, [object, e, s]),
          returnValueForMissingStub: null);
}

/// A class which mocks [Downloader].
///
/// See the documentation for Mockito's code generation for more information.
class MockDownloader extends _i1.Mock implements _i9.Downloader {
  MockDownloader() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get loggerName =>
      (super.noSuchMethod(Invocation.getter(#loggerName), returnValue: '')
          as String);
  @override
  String get executable =>
      (super.noSuchMethod(Invocation.getter(#executable), returnValue: '')
          as String);
  @override
  List<String> get arguments => (super
          .noSuchMethod(Invocation.getter(#arguments), returnValue: <String>[])
      as List<String>);
  @override
  _i2.Logger get logger => (super.noSuchMethod(Invocation.getter(#logger),
      returnValue: _FakeLogger_0()) as _i2.Logger);
  @override
  _i7.Stream<List<int>> get stdout =>
      (super.noSuchMethod(Invocation.getter(#stdout),
          returnValue: Stream<List<int>>.empty()) as _i7.Stream<List<int>>);
  @override
  _i7.Stream<List<int>> get stderr =>
      (super.noSuchMethod(Invocation.getter(#stderr),
          returnValue: Stream<List<int>>.empty()) as _i7.Stream<List<int>>);
  @override
  _i7.Stream<String> get decodedStdout =>
      (super.noSuchMethod(Invocation.getter(#decodedStdout),
          returnValue: Stream<String>.empty()) as _i7.Stream<String>);
  @override
  _i7.Stream<String> get decodedStderr =>
      (super.noSuchMethod(Invocation.getter(#decodedStderr),
          returnValue: Stream<String>.empty()) as _i7.Stream<String>);
  @override
  bool get isSuccess =>
      (super.noSuchMethod(Invocation.getter(#isSuccess), returnValue: false)
          as bool);
  @override
  bool get isTerminated =>
      (super.noSuchMethod(Invocation.getter(#isTerminated), returnValue: false)
          as bool);
  @override
  String get prettyCmd =>
      (super.noSuchMethod(Invocation.getter(#prettyCmd), returnValue: '')
          as String);
  @override
  _i7.Future<void> didStart() =>
      (super.noSuchMethod(Invocation.method(#didStart, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> start() => (super.noSuchMethod(Invocation.method(#start, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> done() => (super.noSuchMethod(Invocation.method(#done, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  String exitMessage() =>
      (super.noSuchMethod(Invocation.method(#exitMessage, []), returnValue: '')
          as String);
  @override
  _i7.Future<void> whileTrueTimeout(
          bool Function()? isTrue, String? streamName) =>
      (super.noSuchMethod(
          Invocation.method(#whileTrueTimeout, [isTrue, streamName]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void terminate() => super.noSuchMethod(Invocation.method(#terminate, []),
      returnValueForMissingStub: null);
}

/// A class which mocks [Unzipper].
///
/// See the documentation for Mockito's code generation for more information.
class MockUnzipper extends _i1.Mock implements _i9.Unzipper {
  MockUnzipper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get loggerName =>
      (super.noSuchMethod(Invocation.getter(#loggerName), returnValue: '')
          as String);
  @override
  String get executable =>
      (super.noSuchMethod(Invocation.getter(#executable), returnValue: '')
          as String);
  @override
  List<String> get arguments => (super
          .noSuchMethod(Invocation.getter(#arguments), returnValue: <String>[])
      as List<String>);
  @override
  _i2.Logger get logger => (super.noSuchMethod(Invocation.getter(#logger),
      returnValue: _FakeLogger_0()) as _i2.Logger);
  @override
  _i7.Stream<List<int>> get stdout =>
      (super.noSuchMethod(Invocation.getter(#stdout),
          returnValue: Stream<List<int>>.empty()) as _i7.Stream<List<int>>);
  @override
  _i7.Stream<List<int>> get stderr =>
      (super.noSuchMethod(Invocation.getter(#stderr),
          returnValue: Stream<List<int>>.empty()) as _i7.Stream<List<int>>);
  @override
  _i7.Stream<String> get decodedStdout =>
      (super.noSuchMethod(Invocation.getter(#decodedStdout),
          returnValue: Stream<String>.empty()) as _i7.Stream<String>);
  @override
  _i7.Stream<String> get decodedStderr =>
      (super.noSuchMethod(Invocation.getter(#decodedStderr),
          returnValue: Stream<String>.empty()) as _i7.Stream<String>);
  @override
  bool get isSuccess =>
      (super.noSuchMethod(Invocation.getter(#isSuccess), returnValue: false)
          as bool);
  @override
  bool get isTerminated =>
      (super.noSuchMethod(Invocation.getter(#isTerminated), returnValue: false)
          as bool);
  @override
  String get prettyCmd =>
      (super.noSuchMethod(Invocation.getter(#prettyCmd), returnValue: '')
          as String);
  @override
  _i7.Future<void> didStart() =>
      (super.noSuchMethod(Invocation.method(#didStart, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> start() => (super.noSuchMethod(Invocation.method(#start, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> done() => (super.noSuchMethod(Invocation.method(#done, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  String exitMessage() =>
      (super.noSuchMethod(Invocation.method(#exitMessage, []), returnValue: '')
          as String);
  @override
  _i7.Future<void> whileTrueTimeout(
          bool Function()? isTrue, String? streamName) =>
      (super.noSuchMethod(
          Invocation.method(#whileTrueTimeout, [isTrue, streamName]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void terminate() => super.noSuchMethod(Invocation.method(#terminate, []),
      returnValueForMissingStub: null);
}
