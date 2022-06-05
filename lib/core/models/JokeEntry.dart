import 'package:flutter/material.dart';

class JokeEntry {
  String joke;
  int index;
  JokeEntry({required this.joke, required this.index});

  JokeEntry.fromJson(Map<String, dynamic> json)
      : joke = json['Joke'],
        index = json['Index'];
}
