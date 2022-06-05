import 'package:dadjoke_client/core/models/JokeEntry.dart';
import 'package:dadjoke_client/widgets/list_entry.dart';

class JokeList {
  List<JokeEntry> list;
  int size;

  JokeList({required this.list, required this.size});

  static List<JokeEntry> _parse_jlist(Map<String, dynamic> json) {
    List<JokeEntry> list = [];
    for (var thing in json['List']) {
      print(thing);

      print("end");
      list.add(JokeEntry.fromJson(thing));
    }
    return list;
  }

  JokeList.fromJson(Map<String, dynamic> json)
      : list = JokeList._parse_jlist(json),
        size = json['Size'];
}
