import 'package:skitracker_client/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  bool checked;
  AnimationController? controller;
  CustomCheckBox({Key? key, required this.checked, this.controller}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        backgroundBlendMode: BlendMode.color,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 4,
            color: BLUR_COLOR,
          )
        ],
      ),
      child: const Icon(Icons.check_circle, color: PRIMARY_COLOR, size: 24),
    );
  }
}
