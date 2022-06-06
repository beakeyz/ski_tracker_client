import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  bool hasFile = false;
  File? checkedFIle;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> checkFile(String file, bool create) async {
    final path = await _localPath;
    File f = File("$path/$file");
    if (f.existsSync()) {
      hasFile = true;
      checkedFIle = f;
      return true;
    }
    if (create) {
      f.createSync();
      hasFile = true;
      checkedFIle = f;
      return true;
    }
    return false;
  }

  void clearFile() {
    hasFile = false;
    checkedFIle = null;
  }

  void write(String file, String contents) async {
    bool success = await checkFile(file, true);
    if (success && checkedFIle != null) {
      checkedFIle!.writeAsStringSync(contents);
      return;
    }
  }
}
