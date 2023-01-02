import 'dart:convert';

import 'package:dadjoke_client/core/models/DataEntry.dart';
import 'package:dadjoke_client/core/models/DataList.dart';
import 'package:dadjoke_client/core/res/JsonFileManager.dart';

import '../res/FileManager.dart';

class LocalStorage extends JsonFileManager {
  static const String PATH = "storage.json";

  void initStorage() async {
    await checkFile(PATH, true).then((value) {
      if (!value) return;
      Map newList = DataList(list: [], size: 0).toJson();
      String jsonString = jsonEncode(newList);
      write(PATH, jsonString);
    });
  }

  Future<DataList> loadStorage() async {
    dynamic list = await loadFromFile(PATH);
    print(list);
    dynamic actualList = DataList.fromJson(list);
    return actualList;
  }

  void saveToStorage(DataEntry entry) async {
    try {
      await loadStorage().then((jokes) {
        DataEntry _entry = entry;
        _entry.index = jokes.size;
        jokes.list.add(_entry);
        jokes.size++;

        String jsonString = jsonEncode(jokes);
        write(PATH, jsonString);
      });
    } catch (ex) {
      print(ex);
    }
  }
}
