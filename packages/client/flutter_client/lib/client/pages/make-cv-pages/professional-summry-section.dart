import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class ProfessionalSummary extends StatefulWidget {
  final CustomInputType inputField;

  const ProfessionalSummary({super.key, required this.inputField});

  @override
  State<ProfessionalSummary> createState() => _ProfessionalSummaryState();
}

class _ProfessionalSummaryState extends State<ProfessionalSummary> {
  final String title = 'Professional Summary';
  final String description =
      'Write 2-4 short & energetic sentences to interest the reader! Mention your role, experience & most importantly - your biggest achievements, best qualities and skills.';
  late CustomInputField __InputFieldWidget;

  @override
  void initState() {
    super.initState();

    // make the input widget
    __InputFieldWidget = CustomInputField(
        label: widget.inputField.label,
        isRequired: widget.inputField.isRequired,
        controller: widget.inputField.controller,
        type: widget.inputField.type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: Text(title),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: Text(description),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: __InputFieldWidget,
          )
        ],
      ),
    );
  }
}
