import 'dart:convert';
import 'dart:io';

import 'package:dadjoke_client/core/models/DataEntry.dart';
import 'package:dadjoke_client/core/models/DataList.dart';
import 'package:dadjoke_client/core/res/JsonFileManager.dart';

import '../res/FileManager.dart';

class LocalStorage extends JsonFileManager {
  static const String PATH = "storage.json";

  void initStorage() async {
    checkFile(PATH, true, (file) {
      if (file != null) return;
      Map newList = DataList(list: [], size: 0).toJson();
      String jsonString = jsonEncode(newList);
      write(PATH, jsonString);
    });
  }

  void loadStorage(Function callback) {
    loadFromFile(PATH, (list) {
      print(list);
      if (list == null) {
        callback(null);
        return;
      }

      try {
        dynamic actualList = DataList.fromJson(list);
        callback(actualList);
      } catch (_) {
        callback(null);
      }
    });
    
  }

  void saveToStorage(DataEntry entry, Function finishedCallback) {
    try {
      loadStorage((list) {
        list ??= DataList(list: [], size: 0);

        DataEntry _entry = entry;
        _entry.index = list.size;
        list.list.add(_entry);
        list.size++;

        String jsonString = jsonEncode(list);
        write(PATH, jsonString);
        finishedCallback();
      });
    } catch (ex) {
      print(ex);
    }
  }
}
