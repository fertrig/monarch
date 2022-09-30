import 'standard_mapper.dart';
import 'target_platform.dart';
import 'logical_resolution.dart';

const iPhone13DeviceDefinition = DeviceDefinition(
  id: 'ios-iphone-13',
  name: 'iPhone 13',
  logicalResolution: LogicalResolution(
    height: 844,
    width: 390,
  ),
  devicePixelRatio: 3.0,
  targetPlatform: MonarchTargetPlatform.iOS,
);

const defaultDeviceDefinition = iPhone13DeviceDefinition;

class DeviceDefinition {
  const DeviceDefinition({
    required this.id,
    required this.name,
    required this.logicalResolution,
    required this.devicePixelRatio,
    required this.targetPlatform,
  });
  final String id, name;
  final MonarchTargetPlatform targetPlatform;
  final LogicalResolution logicalResolution;

  /// Also called: Retina factor, UIKit Scale factor, etc.
  final double devicePixelRatio;
}

class DeviceDefinitionMapper implements StandardMapper<DeviceDefinition> {
  @override
  DeviceDefinition fromStandardMap(Map<String, dynamic> args) =>
      DeviceDefinition(
          id: args['id'],
          name: args['name'],
          logicalResolution: LogicalResolutionMapper().fromStandardMap(
              Map<String, dynamic>.from(args['logicalResolution'])),
          devicePixelRatio: args['devicePixelRatio'],
          targetPlatform: targetPlatformFromString(args['targetPlatform']));

  @override
  Map<String, dynamic> toStandardMap(DeviceDefinition obj) => {
        'id': obj.id,
        'name': obj.name,
        'logicalResolution':
            LogicalResolutionMapper().toStandardMap(obj.logicalResolution),
        'devicePixelRatio': obj.devicePixelRatio,
        'targetPlatform': targetPlatformToString(obj.targetPlatform),
      };
}

class DeviceDefinitionListMapper
    implements StandardMapperList<DeviceDefinition> {
  @override
  List<DeviceDefinition> fromStandardMap(Map<String, dynamic> args) {
    var defsArg = args['definitions'] as List<dynamic>;
    return defsArg
        .map((e) => DeviceDefinitionMapper()
            .fromStandardMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Map<String, dynamic> toStandardMap(List<DeviceDefinition> list) => {
        'definitions': list
            .map((obj) => DeviceDefinitionMapper().toStandardMap(obj))
            .toList(),
      };
}

