import 'package:monarch_controller/data/device_definitions.dart';
import 'package:monarch_controller/data/dock_definition.dart';
import 'package:monarch_controller/data/monarch_data.dart';
import 'package:monarch_controller/data/definitions.dart' as defs;
import 'package:monarch_controller/data/stories.dart';
import 'package:monarch_controller/data/story_scale_definitions.dart';
import 'package:monarch_controller/data/visual_debug_flags.dart';

import '../data/channel_methods.dart';

class ControllerState implements OutboundChannelArgument {
  final bool isReady;
  final String packageName;
  final List<StoryGroup> storyGroups;
  final Set<String> collapsedGroupKeys;
  final String? activeStoryKey;

  final DeviceDefinition currentDevice;
  final List<DeviceDefinition> devices;

  final String currentLocale;
  final List<String> locales;

  final MetaTheme currentTheme;
  final List<MetaTheme> standardThemes;
  final List<MetaTheme> userThemes;

  final StoryScaleDefinition currentScale;

  final List<StoryScaleDefinition> scaleList;

  final DockDefinition currentDock;
  final List<DockDefinition> dockList;

  final double textScaleFactor;
  final List<VisualDebugFlag> visualDebugFlags;

  List<MetaTheme> get allThemes => standardThemes + userThemes;

  ControllerState({
    required this.isReady,
    this.packageName = '',
    this.storyGroups = const [],
    this.activeStoryKey,
    required this.devices,
    required this.currentDevice,
    required this.locales,
    required this.currentLocale,
    required this.standardThemes,
    required this.userThemes,
    required this.currentTheme,
    required this.currentDock,
    required this.currentScale,
    required this.dockList,
    required this.scaleList,
    required this.textScaleFactor,
    required this.visualDebugFlags,
    required this.collapsedGroupKeys,
  });

  factory ControllerState.init() => ControllerState(
        isReady: true,
        collapsedGroupKeys: {},
        storyGroups: [
          StoryGroup(
            groupKey: 'button_stories_key',
            groupName: 'button_stories',
            stories: [
              Story(name: 'pRiMaRy', key: '1'),
              Story(name: 'ALL_CAPS', key: '2'),
              Story(name: 'gone', key: '3'),
            ],
          ),
          StoryGroup(
            groupKey: 'other_stories_key',
            groupName: 'other_stories',
            stories: [
              Story(name: 'pRiMaRy', key: '11'),
              Story(name: 'ALL_CAPS', key: '12'),
              Story(name: 'gone', key: '13'),
            ],
          ),
          StoryGroup(
            groupKey: 'no_stories_key',
            groupName: 'no_stories_here',
            stories: [],
          ),
          StoryGroup(
            groupKey: 'different_stories_key',
            groupName: 'different_stories',
            stories: [
              Story(name: 'hello', key: '21'),
              Story(name: 'world', key: '22'),
              Story(name: 'tester', key: '23'),
            ],
          ),
        ],
        devices: [defaultDeviceDefinition],
        currentDevice: defaultDeviceDefinition,
        locales: [defs.defaultLocale],
        currentLocale: defs.defaultLocale,
        standardThemes: [defs.defaultTheme],
        userThemes: [
          const MetaTheme(id: '1', name: 'hello theme', isDefault: false),
          const MetaTheme(id: '2', name: 'world theme', isDefault: false),
        ],
        currentTheme: defs.defaultTheme,
        currentDock: defs.defaultDock,
        currentScale: defaultScaleDefinition,
        dockList: defs.dockList,
        scaleList: [defaultScaleDefinition],
        visualDebugFlags: defs.devToolsOptions,
        textScaleFactor: 1.0,
      );

  ControllerState copyWith({
    String? activeStoryKey,
    String? packageName,
    List<StoryGroup>? storyGroups,
    bool? isReady,
    List<DeviceDefinition>? devices,
    DeviceDefinition? currentDevice,
    String? currentLocale,
    List<String>? locales,
    MetaTheme? currentTheme,
    List<MetaTheme>? standardThemes,
    List<MetaTheme>? userThemes,
    StoryScaleDefinition? currentScale,
    DockDefinition? currentDock,
    double? textScaleFactor,
    List<VisualDebugFlag>? visualDebugFlags,
    List<StoryScaleDefinition>? scaleList,
  }) =>
      ControllerState(
        activeStoryKey: activeStoryKey ?? this.activeStoryKey,
        storyGroups: storyGroups ?? this.storyGroups,
        isReady: isReady ?? this.isReady,
        devices: devices ?? this.devices,
        currentDevice: currentDevice ?? this.currentDevice,
        locales: locales ?? this.locales,
        currentLocale: currentLocale ?? this.currentLocale,
        standardThemes: standardThemes ?? this.standardThemes,
        userThemes: userThemes ?? this.userThemes,
        currentTheme: currentTheme ?? this.currentTheme,
        scaleList: scaleList ?? this.scaleList,
        currentScale: currentScale ?? this.currentScale,
        dockList: dockList,
        currentDock: currentDock ?? this.currentDock,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        visualDebugFlags: visualDebugFlags ?? this.visualDebugFlags,
        packageName: packageName ?? this.packageName,
        collapsedGroupKeys: collapsedGroupKeys,
      );

  @override
  Map<String, dynamic> toStandardMap() {
    // As of 2022-05, we only return device, scale and dock.
    // In the future, if clients require more state properties then add
    // them as needed.
    return {
      'device': currentDevice.toStandardMap(),
      'scale': currentScale.toStandardMap(),
      'dock': currentDock.id
    };
  }
}
