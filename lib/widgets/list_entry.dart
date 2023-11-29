import 'dart:math';

import 'package:skitracker_client/constants/colors.dart';
import 'package:skitracker_client/core/models/DataEntry.dart';
import 'package:skitracker_client/core/screen_switcher.dart';
import 'package:skitracker_client/screens/home/list_focus.dart';
import "package:flutter/material.dart";
import 'package:flutter_bounce/flutter_bounce.dart';

class ListEntry extends StatefulWidget {
  final DataEntry dataEntry;
  ListEntry({Key? key, required this.dataEntry}) : super(key: key);

  @override
  State<ListEntry> createState() => _ListEntryState();
}

class _ListEntryState extends State<ListEntry> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 75),
      onPressed: () {
        ScreenSwitcher.pushScreen(context, ListFocus(tag: widget));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 72,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation((180 + 60) * (pi / 180)),
            colors: [
              Color.fromARGB(255, 1, 138, 172),
              Color.fromARGB(255, 153, 3, 146),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: Container()),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    widget.dataEntry.date,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Text(
                  widget.dataEntry.date,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Flexible(child: Container()),
              ],
            ),
            Text(
              widget.dataEntry.index.toString(),
              style: const TextStyle(fontSize: 21),
            ),
          ],
        ),
      ),
    );
  }
}
