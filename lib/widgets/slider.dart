import 'package:dadjoke_client/constants/colors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class Slider extends StatefulWidget {
  final Widget child;
  final double minValue;
  final double maxValue;
  double defaultValue;
  
  Slider({super.key, required this.child, required this.minValue, required this.maxValue, required this.defaultValue});

  @override
  State<Slider> createState() => _SliderState();

}

class _SliderState extends State<Slider> {
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