import 'dart:convert';

import 'package:dadjoke_client/core/res/FileManager.dart';
import 'package:flutter/material.dart';

class Setting {
  String name;
  dynamic setting;
  TextEditingController? editingController;

  Setting({required this.name, required this.setting});

  // Does this work?
  void set(dynamic newVal) {
    setting = newVal;
  }

  void setController(TextEditingController controller) {
    editingController = controller;
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
    for (Setting setting in Settings) {
      if (setting.editingController != null) {
        setting.setting = setting.editingController!.text;
      }
    }

    FileManager m = FileManager();
    String jsonString = jsonEncode(Settings);
    m.write(SETTINGS_FILE, jsonString);
  }
}
