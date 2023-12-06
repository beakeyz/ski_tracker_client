import 'dart:convert';

import 'package:skitracker_client/constants/colors.dart';
import 'package:skitracker_client/core/api_calls.dart';
import 'package:skitracker_client/core/models/Settings.dart';
import 'package:skitracker_client/core/res/DataFetcher.dart';
import 'package:skitracker_client/core/res/JsonFileManager.dart';
import 'package:skitracker_client/core/tracker.dart';
import 'package:skitracker_client/core/updates/StateUpdater.dart';
import 'package:skitracker_client/screens/error.dart';
import 'package:skitracker_client/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


void main() {
  // first things first, lets load settings
  WidgetsFlutterBinding.ensureInitialized();

  JsonFileManager m = JsonFileManager();

  addWidgetlessStateUpdator(() {
    StringSetting? host = SettingVars.getByName("Server hostname");
    if (host != null) {
      ApiUtils.setHost(host.value);
    }
  });

  // fetch settings in json
  m.fetchSettings((settingsToLoad) {
    // - if json does not exist, make it and load default settings into it

    if (settingsToLoad == SettingVars.defaultSettings) {
      m.checkFile(SettingVars.SETTINGS_FILE, true, (newFile) {
        if (newFile != null) {
          String contents = jsonEncode(settingsToLoad);
          m.write(SettingVars.SETTINGS_FILE, contents);
        }
      });
    }

    // otherwise, compare to default settings and set accordingly
    SettingVars.settings = settingsToLoad;
    activateStateUpdateWidgets(null);
  });

  ApiUtils.checkForConnection((has) {
    DataFetcher.getPhysicalDevicePosition().then((position) {

      /* Create the tracker instance */
      gTracker = Tracker();

      runApp(
        Main(
          initError: (position == null),
        ),
      );

      App.hasFinish = true;
    });
  });

  while (App.hasFinish == false) {}
}

class App {
  static bool hasServer = true;
  static bool hasLocationAlways = false;
  static bool hasFinish = false;
}

class Main extends StatelessWidget {
  final bool initError;
  const Main({Key? key, required this.initError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: ((context, child) {
        return ScrollConfiguration(
          behavior: AppBehavior(),
          child: child!,
        );
      }),
      title: "Ski Tracker client",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: BACKGROUND_COLOR),
      home: Scaffold(
        body: 
        ((initError) ?
        const ErrorScreen(E_FAIL)
        : const LoginScreen()),
      ),
    );
  }
}

class AppBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
