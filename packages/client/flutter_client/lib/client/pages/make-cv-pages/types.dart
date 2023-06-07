import 'package:flutter/material.dart';

class CustomInputType {
  final String label;
  final String jsonKey;
  final bool isRequired;
  final TextInputType type;
  final TextEditingController controller;

  CustomInputType(
    this.label,
    this.jsonKey,
    this.isRequired,
    this.controller,
    this.type,
  );
}

typedef DeleteFunction = void Function(int index);
typedef GetJSONFunction = String Function();
