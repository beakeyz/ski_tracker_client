import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  bool hasFile = false;
  File? checkedFIle;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    for (FileSystemEntity thiing in directory.listSync()) {
      print(thiing.path);
    }
    return directory.path;
  }

  Future<bool> checkFile(String file, bool create) async {
    final path = await _localPath;
    File f = File("$path/$file");
    if (f.existsSync()) {
      print("Yes");
      hasFile = true;
      checkedFIle = f;
      return true;
    }
    if (create) {
      print("Kinda");
      f.createSync();
      hasFile = true;
      checkedFIle = f;
      return true;
    }
    print("just no");
    return false;
  }

  void clearFile() {
    hasFile = false;
    checkedFIle = null;
  }

  void write(String file, String contents) async {
    bool success = await checkFile(file, true);
    if (success && checkedFIle != null) {
      print("YES");
      checkedFIle!.writeAsStringSync(contents);
      return;
    }
    print("No");
  }
}
