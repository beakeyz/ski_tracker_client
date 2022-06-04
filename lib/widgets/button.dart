import 'dart:math';

import 'package:dadjoke_client/constants/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Function callback;
  final String text;
  Button({Key? key, required this.callback, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback.call();
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            transform: GradientRotation(130 * (pi / 180)),
            colors: [
              Color.fromARGB(244, 186, 28, 214),
              Colors.blue,
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: BLUR_COLOR,
              blurRadius: 14,
              spreadRadius: 3,
              blurStyle: BlurStyle.normal,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(text),
      ),
    );
  }
}
