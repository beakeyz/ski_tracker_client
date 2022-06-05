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

  void checkFile(String file) async {
    final path = await _localPath;
    File f = File("$path/$file");
    f.exists().then((value) {
      hasFile = value;
      checkedFIle = f;
    });
  }

  void clearFile() {
    hasFile = false;
    checkedFIle = null;
  }

  void write() async {}
}
