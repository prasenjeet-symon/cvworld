// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Function to parse a formatted date string back into a DateTime object
DateTime parseDate(String formattedDate) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Match the date format you used when formatting
  return formatter.parse(formattedDate);
}

// Function to format a DateTime object as a human-readable date
String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd'); // You can change the date format as needed
  return formatter.format(dateTime);
}

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
      firstDate: DateTime(1700),
      lastDate: DateTime(2300),
    );

    if (dateTime == null) {
    } else {
      widget.controller.text = formatDateTime(dateTime);
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
