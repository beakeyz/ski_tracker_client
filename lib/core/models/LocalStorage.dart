import 'dart:convert';

import 'package:dadjoke_client/core/models/JokeEntry.dart';
import 'package:dadjoke_client/core/models/JokeList.dart';
import 'package:dadjoke_client/core/res/JsonFileManager.dart';

import '../res/FileManager.dart';

class LocalStorage extends JsonFileManager {
  static const String PATH = "storage.json";

  void initStorage() async {
    await checkFile(PATH, true).then((value) {
      if (!value) return;
      Map newList = JokeList(list: [], size: 0).toJson();
      String jsonString = jsonEncode(newList);
      write(PATH, jsonString);
    });
  }

  Future<JokeList> loadStorage() async {
    dynamic list = await loadFromFile(PATH);
    print(list);
    dynamic actualList = JokeList.fromJson(list);
    return actualList;
  }

  void saveToStorage(JokeEntry entry) async {
    try {
      await loadStorage().then((jokes) {
        JokeEntry _entry = entry;
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
