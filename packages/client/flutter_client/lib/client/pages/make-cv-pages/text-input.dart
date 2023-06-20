// ignore: file_names
import 'dart:js_interop';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
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
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  Future<void> _showDatePicker() async {
    var dateTime = await showDatePicker(
      context: context,
      initialDate: widget.controller.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(widget.controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dateTime.isNull) {
      // closed
    } else {
      // selected
      widget.controller.text = (dateTime as DateTime).toIso8601String();
    }
  }

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
    return TextFormField(
      onTap: () => {
        widget.type == TextInputType.datetime ? _showDatePicker() : () => {}
      },
      controller: widget.controller,
      keyboardType: widget.type,
      maxLines: widget.isTextArea.isNull ? 1 : null, // Allow unlimited lines
      decoration: InputDecoration(
        fillColor: Colors.grey[200], // Set the background color
        filled: true, // Fill the input field
        border: OutlineInputBorder(
          // Customize the border
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide.none,
        ),
        labelText: widget.label,
        hintText: widget.isRequired ? 'Required' : '',
      ),
      validator: widget.isRequired
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
