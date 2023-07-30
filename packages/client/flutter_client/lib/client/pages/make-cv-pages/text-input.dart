import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final TextInputType type;
  final bool isTextArea;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.isRequired,
    required this.controller,
    required this.type,
    this.isTextArea = false, // Set default value to false
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  Future<void> _showDatePicker() async {
    var dateTime = await showDatePicker(
      context: context,
      initialDate: widget.controller.text.isEmpty ? DateTime.now() : DateTime.parse(widget.controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (dateTime == null) {
      // DatePicker was closed
      Fluttertoast.showToast(msg: 'DatePicker was closed');
    } else {
      // DatePicker selected
      widget.controller.text = (dateTime).toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => widget.type == TextInputType.datetime ? _showDatePicker() : null,
      controller: widget.controller,
      keyboardType: widget.type,
      maxLines: widget.isTextArea ? null : 1, // Allow unlimited lines for TextArea
      decoration: InputDecoration(
        fillColor: Colors.grey[200], // Set the background color
        filled: true, // Fill the input field
        border: OutlineInputBorder(
          // Customize the border
          borderRadius: BorderRadius.circular(1.0),
          borderSide: BorderSide.none,
        ),
        labelText: widget.label,
        hintText: widget.isRequired ? 'Required' : 'Optional', // Show that it is optional if not required
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
