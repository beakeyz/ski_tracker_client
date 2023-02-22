import 'package:flutter/material.dart';

class DataEntry {
  int distance;
  double max_speed;
  String Date;
  int index;
  DataEntry({required this.distance, required this.max_speed, required this.Date, required this.index});

  DataEntry.fromJson(Map<String, dynamic> json)
      : distance = json['Distance'],
        max_speed = json['MaxSpeed'],
        Date = json['Date'],
        index = json['Index'];

  Map<String, dynamic> toJson() => {
        'Distance': distance,
        'MaxSpeed': max_speed,
        'Date': Date,
        'Index': index,
      };
}
