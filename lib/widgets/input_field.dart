
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController editingController;
  final bool shouldHideInput;
  final String hintText;
  final TextInputType textInputType;
  final double boxWidth;
  const TextInputField({Key? key, required this.editingController, this.shouldHideInput = false, this.boxWidth = double.infinity, required this.hintText, required this.textInputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: boxWidth,
      child: TextField(
        controller: editingController,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
          border: UnderlineInputBorder(
            borderSide: Divider.createBorderSide(context),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: Divider.createBorderSide(context),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: Divider.createBorderSide(context),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
        ),
        keyboardType: textInputType,
        obscureText: shouldHideInput,
      ),
    );
  }
}
