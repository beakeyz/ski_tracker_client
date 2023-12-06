import 'package:skitracker_client/constants/colors.dart';
import 'package:skitracker_client/core/api_calls.dart';
import 'package:skitracker_client/core/models/Settings.dart';
import 'package:skitracker_client/core/screen_switcher.dart';
import 'package:skitracker_client/widgets/button.dart';
import 'package:skitracker_client/widgets/setting_view.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                ScreenSwitcher.popScreen(context);
              },
              child: const Icon(Icons.arrow_back_ios_new, size: 25),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
          ],
          shape: const Border(
            bottom: BorderSide(
              color: SECONDARY_COLOR,
              width: 2,
            ),
          ),
          shadowColor: SECONDARY_COLOR,
          backgroundColor: BACKGROUND_COLOR,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: SettingVars.settings.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: SettingView(settingField: SettingVars.settings[index]),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: SECONDARY_COLOR,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(185, 117, 107, 118),
                    blurRadius: 15,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Button(
                callback: () {
                  // TODO save
                  SettingVars.save();
                  ApiUtils.verifyHost((res) {
                    if (res) {
                      Setting? host = SettingVars.getByName("Server hostname");
                      if (host != null && host is StringSetting) {
                        ApiUtils.setHost(host.value);
                      }
                    }
                  });
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontFamily: "Open Sans",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
