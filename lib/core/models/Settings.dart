import 'dart:convert';

import 'package:dadjoke_client/core/res/FileManager.dart';

class Setting {
  String name;
  dynamic setting;

  Setting({required this.name, required this.setting});

  // Does this work?
  void set(dynamic newVal) {
    setting = newVal;
  }

  Setting.fromJson(Map<String, dynamic> json)
      : name = json['SettingName'],
        setting = json['Value'];

  Map<String, dynamic> toJson() => {
        'SettingName': name,
        'Value': setting,
      };
}

class SettingVars {
  static const String SETTINGS_FILE = "settings.json";

  static var Settings = [
    Setting(name: "Test", setting: false),
    Setting(name: "Test2", setting: "Something"),
  ];

  static void save() {
    FileManager m = FileManager();
    String jsonString = jsonEncode(Settings);
    m.write(SETTINGS_FILE, jsonString);
  }
}
