import 'dart:math';

import 'package:dadjoke_client/constants/colors.dart';
import "package:flutter/material.dart";

class ListEntry extends StatefulWidget {
  final String Joke;
  ListEntry({Key? key, required this.Joke}) : super(key: key);

  @override
  State<ListEntry> createState() => _ListEntryState();
}

class _ListEntryState extends State<ListEntry> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation((180 + 60) * (pi / 180)),
            colors: [
              Color.fromARGB(244, 128, 112, 112),
              Color.fromARGB(252, 111, 0, 255),
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(21),
          ),
          boxShadow: [
            BoxShadow(
              color: BLUR_COLOR,
              blurRadius: 14,
              spreadRadius: 3,
              blurStyle: BlurStyle.normal,
              offset: Offset(1, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            widget.Joke,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }
}
