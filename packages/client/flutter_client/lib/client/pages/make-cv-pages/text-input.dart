// ignore: file_names
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final TextInputType type;

  const CustomInputField({
    super.key,
    required this.label,
    required this.isRequired,
    required this.controller,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
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
