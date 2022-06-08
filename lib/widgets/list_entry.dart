import 'dart:math';

import 'package:dadjoke_client/constants/colors.dart';
import 'package:dadjoke_client/core/models/JokeEntry.dart';
import 'package:dadjoke_client/core/screen_switcher.dart';
import 'package:dadjoke_client/screens/home/list_focus.dart';
import "package:flutter/material.dart";
import 'package:flutter_bounce/flutter_bounce.dart';

class ListEntry extends StatefulWidget {
  final JokeEntry Joke;
  ListEntry({Key? key, required this.Joke}) : super(key: key);

  @override
  State<ListEntry> createState() => _ListEntryState();
}

class _ListEntryState extends State<ListEntry> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 75),
      onPressed: () {
        ScreenSwitcher.pushScreen(context, ListFocus(tag: widget));
      },
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation((180 + 60) * (pi / 180)),
            colors: [
              Color.fromARGB(244, 67, 55, 68),
              Color.fromARGB(160, 153, 3, 146),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(21),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: Container()),
                Container(
                  width: 300,
                  child: Text(
                    widget.Joke.Summary,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  widget.Joke.Date,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Flexible(child: Container()),
              ],
            ),
            Flexible(child: Container()),
            Text(widget.Joke.index.toString()),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
