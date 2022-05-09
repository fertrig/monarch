import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:monarch_utils/log_config.dart';

import 'package:monarch_controller/utils/localization.dart';
import 'package:monarch_controller/default_theme.dart'
    as theme;
import 'package:monarch_controller/manager/controller_manager.dart';
import 'package:monarch_controller/screens/window_controller_screen.dart';
import 'package:monarch_controller/data/channel_methods_receiver.dart';

const controlsWidth = 250.0;
final manager = ControllerManager();

void main() async {
  _setUpLog();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  receiveChannelMethodCalls();
}

void _setUpLog() {
  // ignore: avoid_print
  writeLogEntryStream((String line) => print('controller: $line'),
      printTimestamp: false, printLoggerName: true);
}

class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Window Controller',
        theme: theme.theme,
        home:  WindowControllerScreen(manager: manager),
        localizationsDelegates: [
          localizationDelegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales);
  }
}
