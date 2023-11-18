// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Convert UTC ( from server date ) to local datetime
DateTime toLocalDateTime(DateTime utcDateTime) {
  return utcDateTime.toLocal();
}

// Function to parse a formatted date string back into a DateTime object
DateTime parseDate(String formattedDate) {
  return DateFormat('yyyy-MM-dd').parse(formattedDate).toLocal();
}

// Function to format a DateTime object as a human-readable date
String formatDateTime(DateTime utcDateTime) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(toLocalDateTime(utcDateTime));
  return formattedDate;
}

DateTime getCurrentDatetime() {
  return DateTime.now().toLocal();
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
      initialDate: widget.controller.text.isEmpty ? getCurrentDatetime() : parseDate(widget.controller.text),
      firstDate: DateTime(1700).toLocal(),
      lastDate: getCurrentDatetime(),
    );

    if (dateTime != null) {
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.0), borderSide: BorderSide.none),
        labelText: widget.type == TextInputType.datetime ? 'Choose Date' : widget.label,
        suffixIcon: widget.type == TextInputType.datetime
            ? IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () => _showDatePicker(),
              )
            : null,
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
