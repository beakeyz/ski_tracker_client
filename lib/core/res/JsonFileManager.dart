import 'dart:convert';
import 'dart:io';

import 'package:dadjoke_client/core/models/Settings.dart';
import 'package:dadjoke_client/core/res/FileManager.dart';

class JsonFileManager extends FileManager {
  void loadFromFile(String file, Function callback) {
    checkFile(file, true, (success) {
      if (success != null && success is File) {
        String data = success.readAsStringSync();
        dynamic thing;
        try {
          thing = jsonDecode(data) as List<dynamic>;
        } catch (e) {
          try {
            thing = jsonDecode(data);
          } catch (e) {
            print("Double fault while trying to decode sjit");
            callback(null);
            return;
          }
        }
        callback(thing);
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

      for (Setting setting in SettingVars.DefaultSettings) {
        bool foundThisSetting = false;
        for (var _loadedSetting in value) {
          Setting loadedSetting = EmptySetting.fromJson(_loadedSetting);

          // json has defaultsetting entry
          if (loadedSetting.name == setting.name) {
            switch (loadedSetting.type) {
              case BOOL_SETTING_TYPE:
                loadedSetting = BoolSetting.fromJson(_loadedSetting);
                break;
              case STRING_SETTING_TYPE:
                loadedSetting = StringSetting.fromJson(_loadedSetting);
                break;
              case SLIDER_SETTING_TYPE:
                loadedSetting = SliderSetting.fromJson(_loadedSetting);
                if (loadedSetting is SliderSetting) {
                  loadedSetting.maxValue = (setting as SliderSetting).maxValue;
                  loadedSetting.minValue = (setting as SliderSetting).minValue;
                }
                break;
              case -1:
                // TODO: add invalid setting type
                break;
            }
            ret.add(loadedSetting);
            foundThisSetting = true;
            break;
          }
        }

        if (!foundThisSetting) {
          ret.add(setting);
        }
      }
      print("DEBUG: returned json-backed settings");
      callback(ret);
    });
  }
}
