

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
      child: Row(
        children: [
          Flexible(
            flex: 100,
            child: Container()
          ),
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.blue,
            ),
          ),
          Flexible(
            flex: 100,
            child: Container()
          ),
        ],
      ),
    );
  }
}