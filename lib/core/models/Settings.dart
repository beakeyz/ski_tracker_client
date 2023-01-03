import 'dart:convert';

import 'package:dadjoke_client/core/res/FileManager.dart';
import 'package:flutter/material.dart';

const String _Setting_json_name_str = "SettingName";

const int BOOL_SETTING_TYPE = 0;
const int STRING_SETTING_TYPE = 1;
const int SLIDER_SETTING_TYPE = 2;

abstract class Setting {
  String name;
  int type;

  Setting(this.name, this.type);

}

class EmptySetting extends Setting {

  EmptySetting(super.name, super.type);

  factory EmptySetting.fromJson(Map<String, dynamic> json) {
    return EmptySetting(json[_Setting_json_name_str], json['Type']);
  }
}

class BoolSetting extends Setting {
  bool value;

  BoolSetting(super.name, super.type, this.value);

  factory BoolSetting.fromJson(Map<String, dynamic> json) {
    if (json['Type'].toString() != BOOL_SETTING_TYPE.toString()) {
      return BoolSetting("NULL", -1, false);
    }
    return BoolSetting(json[_Setting_json_name_str], json['Type'], json['Value']); 
  }

  @override
  Map<String, dynamic> toJson() => {
        'SettingName': name,
        'Type': type,
        'Value': value,
      };
}

class StringSetting extends Setting {
  String value;
  TextEditingController? editingController;

  StringSetting(super.name, super.type, this.value);

  void setController(TextEditingController controller) {
    editingController = controller;
  }

  factory StringSetting.fromJson(Map<String, dynamic> json) {
    if (json['Type'].toString() != STRING_SETTING_TYPE.toString()) {
      return StringSetting("NULL", -1, "NOTHING");
    }
    return StringSetting(json[_Setting_json_name_str], json['Type'], json['Value']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'SettingName': name,
        'Type': type,
        'Value': value,
      };
}

class SliderSetting extends Setting {
  num minValue;
  num maxValue;
  num value;

  SliderSetting(super.name, super.type, this.minValue, this.maxValue, this.value);

  factory SliderSetting.fromJson(Map<String, dynamic> json) {
    if (json['Type'].toString() != SLIDER_SETTING_TYPE.toString()) {
      return SliderSetting("NULL", -1, -1, -1, -1);
    }
    return SliderSetting(json[_Setting_json_name_str], json['Type'], json['MinValue'], json['MaxValue'], json['Value']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'SettingName': name,
        'Type': type,
        'Value': value,
        'MinValue':minValue,
        'MaxValue':maxValue,
      };
}

class SettingVars {
  static const String SETTINGS_FILE = "settings.json";

  static List<Setting> DefaultSettings = [
    BoolSetting("I know what i'm doing", BOOL_SETTING_TYPE, false),
    StringSetting("Server hostname", STRING_SETTING_TYPE, "192.168.0.45:4000"),
    SliderSetting("Frequency", SLIDER_SETTING_TYPE, 2, 1, 10),
  ];

  static List<Setting> Settings = [];

  static dynamic getByName(String name) {
    for (Setting s in Settings) {
      if (s.name == name) {
        return s;
      }
    }
    return null;
  }

  static dynamic fromJson(dynamic input){
    EmptySetting setting = EmptySetting.fromJson(input);
    print(setting.type.toString());
    switch (setting.type) {
      case -1:
        return null;
      case BOOL_SETTING_TYPE:
        return BoolSetting.fromJson(input);
      case STRING_SETTING_TYPE:
        return StringSetting.fromJson(input);
      case SLIDER_SETTING_TYPE:
        return SliderSetting.fromJson(input);
      default:
    }
    return null;
  }

  static void save() {
    for (Setting setting in Settings) {
      if (setting is StringSetting) {
        StringSetting s = setting;
        s.value = s.editingController!.text;
      }
    }

    FileManager m = FileManager();
    String jsonString = jsonEncode(Settings);
    m.write(SETTINGS_FILE, jsonString);
  }
}
