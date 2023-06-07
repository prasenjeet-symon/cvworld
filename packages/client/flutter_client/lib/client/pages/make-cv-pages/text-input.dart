// ignore: file_names
import 'dart:js_interop';

import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final TextInputType type;
  bool? isTextArea;

  CustomInputField(
      {super.key,
      required this.label,
      required this.isRequired,
      required this.controller,
      required this.type,
      this.isTextArea});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: isTextArea.isNull ? 1 : null, // Allow unlimited lines
      decoration: InputDecoration(
        fillColor: Colors.grey[200], // Set the background color
        filled: true, // Fill the input field
        border: OutlineInputBorder(
          // Customize the border
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide.none,
        ),
        labelText: label,
        hintText: isRequired ? 'Required' : '',
      ),
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
          : null,
    );
  }
}
