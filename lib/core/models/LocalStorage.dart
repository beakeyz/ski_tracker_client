import 'dart:convert';

import 'package:skitracker_client/core/models/DataEntry.dart';
import 'package:skitracker_client/core/models/DataList.dart';
import 'package:skitracker_client/core/res/JsonFileManager.dart';


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

        DataEntry entry0 = entry;
        entry0.index = list.size;
        list.list.add(entry0);
        list.size++;

        String jsonString = jsonEncode(list);
        write(PATH, jsonString);
        finishedCallback();
      });
    } catch (ex) {
      print(ex);
    }
  }

  bool removeFromStorage(int index, Function? finishedCallback)
  {
    DataList list;
    DataEntry? removedEntry;

    try {
      loadStorage((list) {
        if (list == null) {
          return false;
        }

        list = list;

        if (index >= list.size) {
          return false;
        }

        removedEntry = list.list.removeAt(index);

        /* Seems like the entry does not exist =/ */
        if (removedEntry == null) {
          return false;
        }

        list.size--;

        for (int i = index; i < list.size; i++) {
          removedEntry = list.list[i];

          if (removedEntry == null) {
            break;
          }

          /* Resolve every index after this one */
          removedEntry!.index--;
        }

        /* Write our changes to disk */
        String jsonString = jsonEncode(list);
        write(PATH, jsonString);

        if (finishedCallback != null) {
          finishedCallback();
        }
      });
    } catch (ex) {
      print(ex);
      return false;
    }

    return true;
  }
}