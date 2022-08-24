import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'paths.dart';
import 'utils.dart' as utils;

List<String> read_flutter_sdks() {
  var yaml = readLocalSettingsYaml();
  var key = 'local_flutter_sdks';
  if (!yaml.containsKey(key))
    throw 'Expected to find `$key` in ${local_settings_yaml}';
  var sdks = yaml[key];
  if (!(sdks is YamlList))
    throw '`$key` in ${local_settings_yaml} should be yaml list';
  if (sdks.isEmpty) throw '`$key` should not be empty';
  return sdks.nodes.map((sdk) => sdk.value.toString()).toList();
}

String read_deployment() {
  var yaml = readLocalSettingsYaml();
  var key = 'deployment';
  if (!yaml.containsKey(key)) return 'local';
  return yaml[key].toString();
}

String getVersionSuffix(String version) {
  var deployment = read_deployment();
  return deployment == 'prod' ? version : '$version-$deployment';
}

YamlMap readLocalSettingsYaml() {
  var file = File(p.join(local_repo_paths.tools, local_settings_yaml));
  if (!file.existsSync())
    throw 'Make sure you create $local_settings_yaml inside the tools directory';
  var contents = file.readAsStringSync();
  return loadYaml(contents) as YamlMap;
}

void writeInternalFile(String name, String contents) {
  utils.createDirectoryIfNeeded(local_out_paths.out_bin_internal);
  var file = File(p.join(local_out_paths.out_bin_internal, name));
  file.writeAsStringSync(contents, mode: FileMode.writeOnly);
}
