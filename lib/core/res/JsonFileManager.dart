import 'dart:convert';
import 'dart:io';

import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/core/res/FileManager.dart';

class JsonFileManager extends FileManager {
  void loadFromFile(String file, Function callback) {
    checkFile(file, true, (success) {
      if (success != null && success is File) {
        String data = success.readAsStringSync();
        try {
          List<dynamic> thing = jsonDecode(data);
          callback(thing);
        } catch (e) {
          try {
            dynamic thing = jsonDecode(data);
            callback(thing);
          } catch (e) {
            print("Double fault while trying to decode sjit");
            callback(null);
          }
        }
      }  
    });
  }

  // SETTINGS

  void fetchSettings (Function callback) {
    loadFromFile(SettingVars.SETTINGS_FILE, (value) {
      if (value == null) {
        print("Could not load settings from json!");
        // TODO: write default settings
        callback(SettingVars.DefaultSettings);
        return;
      }
      print("returning funnie");
      List<Setting> ret = [];
      for (var s in value) {
        Setting setting = EmptySetting.fromJson(s);

        switch (setting.type) {
          case BOOL_SETTING_TYPE:
            setting = BoolSetting.fromJson(s);
            ret.add(setting);
            break;
          case STRING_SETTING_TYPE:
            setting = StringSetting.fromJson(s);
            ret.add(setting);
            break;
          case SLIDER_SETTING_TYPE:
            setting = SliderSetting.fromJson(s);
            ret.add(setting);
            break;
          case -1:
            // TODO: add invalid setting type
            break;
        }
      }
      print("DEBUG: returned json-backed settings");
      callback(ret);
    });
  }
}
