import 'package:dadjoke_client/core/models/DataEntry.dart';
import 'package:dadjoke_client/widgets/list_entry.dart';

class DataList {
  List<DataEntry> list;
  int size;

  DataList({required this.list, required this.size});

  static List<DataEntry> _parse_jlist(Map<String, dynamic> json) {
    List<DataEntry> list = [];
    for (var thing in json['List']) {
      print(thing);

      print("end");
      list.add(DataEntry.fromJson(thing));
    }
    return list;
  }

  DataList.fromJson(Map<String, dynamic> json)
      : list = DataList._parse_jlist(json),
        size = json['Size'];

  Map<String, dynamic> toJson() => {
        'List': list,
        'Size': size,
      };
}
