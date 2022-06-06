import 'dart:convert';

import 'package:dadjoke_client/core/res/FileManager.dart';

class JsonFileManager extends FileManager {
  Future<dynamic> loadFromFile(String file) async {
    bool succes = await checkFile(file, false);
    if (succes) {
      String data = checkedFIle!.readAsStringSync();
      try {
        dynamic thing = jsonDecode(data);
        return thing;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}
