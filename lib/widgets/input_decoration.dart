import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration(
      {context,
      required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2)),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Theme.of(context).primaryColor)
            : null);
  }
}
