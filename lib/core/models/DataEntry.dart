import 'package:flutter/material.dart';

class DataEntry {
  String Summary;
  String joke;
  String Date;
  int index;
  DataEntry({required this.Summary, required this.joke, required this.Date, required this.index});

  DataEntry.fromJson(Map<String, dynamic> json)
      : Summary = json['Summary'],
        joke = json['Joke'],
        Date = json['Date'],
        index = json['Index'];

  Map<String, dynamic> toJson() => {
        'Summary': Summary,
        'Joke': joke,
        'Date': Date,
        'Index': index,
      };
}
