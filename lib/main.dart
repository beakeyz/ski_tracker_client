import 'dart:convert';
import 'dart:io';

import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/StateLock.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/core/res/JsonFileManager.dart';
import 'package:dadjoke_client/core/updates/StateUpdater.dart';
import 'package:dadjoke_client/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  // first things first, lets load settings
  WidgetsFlutterBinding.ensureInitialized();

  JsonFileManager m = JsonFileManager();

  print("${SettingVars.Settings.length} hihi");

  print("Processing...");

  // fetch settings in json
  m.fetchSettings((settingsToLoad) {
    // - if json does not exist, make it and load default settings into it

    if (settingsToLoad == SettingVars.DefaultSettings) {
      print("Detected default settings! writing to json...");
      m.checkFile(SettingVars.SETTINGS_FILE, true, (new_file) {
        if (new_file != null) {
          String contents = jsonEncode(settingsToLoad);
          m.write(SettingVars.SETTINGS_FILE, contents);
        } else {
          print("ERROR: new_file is null");
        }
      });
    }

    // otherwise, compare to default settings and set accordingly
    SettingVars.Settings = settingsToLoad;
    activateStateUpdateWidgets(null);
  });

  ApiUtils.checkForConnection((has) {
    print(has);
    runApp(
      Main(
        has_internet: has as bool,
      ),
    );
  });
}

class App {
  static bool hasServer = true;
}

class Main extends StatelessWidget {
  final bool has_internet;
  const Main({Key? key, required this.has_internet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    // TODO
    addWidgetlessStateUpdator(() {
      StringSetting? host = SettingVars.getByName("Server hostname");
      if (host != null) {
        print("host: ${host.value}");
        ApiUtils.setHost(host.value);
      } else {
        // TODO: show erro screen
        print("ERROR: could not get BASE_URL from settings");
      }
    });

    return MaterialApp(
      builder: ((context, child) {
        return ScrollConfiguration(
          behavior: AppBehavior(),
          child: child!,
        );
      }),
      title: "Dadjokegen client",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: BACKGROUND_COLOR),
      home: const Scaffold(
        body: LoginScreen(),
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
