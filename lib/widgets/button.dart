import 'dart:math';

import 'package:dadjoke_client/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class Button extends StatefulWidget {
  Function callback;
  final Widget child;
  Button({Key? key, required this.callback, required this.child}) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 150),
      onPressed: () {
        widget.callback.call();
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
              offset: Offset(1, 3),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
