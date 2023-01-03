import 'package:dadjoke_client/constants/colors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final Widget child;
  final num minValue;
  final num maxValue;
  num defaultValue;
  
  CustomSlider({super.key, required this.child, required this.minValue, required this.maxValue, required this.defaultValue});

  @override
  State<CustomSlider> createState() => _CustomSliderState();

}

class _CustomSliderState extends State<CustomSlider> {
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
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: Colors.amber,
    );
  }
}