import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/widgets/button.dart';
import 'package:dadjoke_client/widgets/setting_view.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
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
              child: const Icon(Icons.arrow_back_ios_new, size: 35),
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
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: SettingVars.Settings.length,
                  itemBuilder: (context, index) {
                    return SettingView(setting: SettingVars.Settings[index]);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Button(
                  callback: () {
                    // TODO save
                    SettingVars.save();
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
        ),
      );
}
