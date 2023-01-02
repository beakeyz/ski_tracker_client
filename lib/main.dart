import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/api_calls.dart';
import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/core/res/JsonFileManager.dart';
import 'package:dadjoke_client/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  ApiUtils.checkForConnection((has) {
    bool _has = has;
    print(_has);
    runApp(
      Main(
        has_internet: _has,
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
    //TODO: clean up this setup
    JsonFileManager m = JsonFileManager();

    print("Processing...");
    m.processDifferences(SettingVars.SETTINGS_FILE).then((_) {
      print("Done");
      m.loadFromFile(SettingVars.SETTINGS_FILE).then((settings) {
        if (settings != null) {
          List<Setting> sets = [];
          for (var set in settings) {
            sets.add(Setting.fromJson(set));
          }
          SettingVars.Settings = sets;
        } else {
          print("null");
        }
      });
    });

    // TODO
    Setting? host = SettingVars.getByName("Server hostname");
    if (host != null) {
      ApiUtils.setHost(host.setting);
    } else {
      // TODO: show erro screen
      print("ERROR: could not get BASE_URL from settings");
    }

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
