import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void checkFile(String file, bool create, Function callback) {
    try {
      _localPath.then((path) {
        File f = File("$path/$file");
        if (f.existsSync()) {
          callback(f);
          return;
        }
        if (create) {
          f.createSync(recursive: true);
          callback(f);
          return;
        }
        callback(null);
      });
    } catch (e) {
      print("Exeption while checking file $file");
      print(e);
    }
  }

  void write(String file, String contents) {
    checkFile(file, true, (success) {
      if (success != null) {
        success.writeAsStringSync(contents);
        return;
      }
    });
  }
}
