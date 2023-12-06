import 'dart:convert';

import 'package:skitracker_client/core/res/FileManager.dart';
import 'package:flutter/material.dart';
import 'package:skitracker_client/core/tracker.dart';

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

  Function(SliderSetting)? onChanged;

  SliderSetting(super.name, super.type, this.minValue, this.maxValue, this.value, this.onChanged);

  factory SliderSetting.fromJson(Map<String, dynamic> json) {
    if (json['Type'].toString() != SLIDER_SETTING_TYPE.toString()) {
      return SliderSetting("NULL", -1, -1, -1, -1, null);
    }
    return SliderSetting(
      json[_Setting_json_name_str],
      json['Type'],
      json['MinValue'],
      json['MaxValue'],
      json['Value'],
      SettingVars.getCallbackFor(json[_Setting_json_name_str])
    );
  }

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

  static List<Setting> defaultSettings = [
    BoolSetting("I know what i'm doing", BOOL_SETTING_TYPE, false),
    StringSetting("Server hostname", STRING_SETTING_TYPE, "192.168.0.45:4000"),
    SliderSetting("Frequency", SLIDER_SETTING_TYPE, 100, 1000, 250, trackerUpdateFrequency),
    BoolSetting("One more time", BOOL_SETTING_TYPE, true),
    BoolSetting("or not", BOOL_SETTING_TYPE, true),
  ];

  static List<Setting> settings = [];

  static dynamic getByName(String name) {
    for (Setting s in settings) {
      if (s.name == name) {
        return s;
      }
    }
    return null;
  }

  static Function(SliderSetting)? getCallbackFor(String settingName)
  {
    Setting? setting;
    SliderSetting sliderSetting;

    setting = SettingVars.getByName(settingName);

    if (setting == null || setting is! SliderSetting) {
      return null;
    }

    sliderSetting = setting;

    return sliderSetting.onChanged;
  }

  static dynamic fromJson(dynamic input){
    EmptySetting setting = EmptySetting.fromJson(input);
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
    for (Setting setting in settings) {
      if (setting is StringSetting) {
        StringSetting s = setting;
        s.value = s.editingController!.text;
      }
    }

    FileManager m = FileManager();
    String jsonString = jsonEncode(settings);
    m.write(SETTINGS_FILE, jsonString);
  }
}
