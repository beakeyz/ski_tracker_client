import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  bool hasFile = false;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  void checkFile() async {
    final path = await _localPath;
    File f = File("$path/data.txt");
    f.exists().then((value) {
      hasFile = value;
    });
  }

  void write() async {}
}
