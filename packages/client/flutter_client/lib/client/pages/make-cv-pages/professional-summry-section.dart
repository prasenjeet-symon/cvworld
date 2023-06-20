import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class ProfessionalSummary extends StatefulWidget {
  final String title;
  final String description;

  const ProfessionalSummary(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<ProfessionalSummary> createState() => ProfessionalSummaryState();
}

class ProfessionalSummaryState extends State<ProfessionalSummary> {
  getData() {
    return {'profile': _controller.text};
  }

  final TextEditingController _controller = TextEditingController();
  late final CustomInputField textEditor;

  @override
  void initState() {
    super.initState();

    final CustomInputType textEditorType = CustomInputType('Summery',
        'professionalSummery', true, _controller, TextInputType.multiline);

    textEditor = CustomInputField(
      label: textEditorType.label,
      isRequired: textEditorType.isRequired,
      controller: textEditorType.controller,
      type: textEditorType.type,
      isTextArea: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              widget.description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: textEditor,
          )
        ],
      ),
    );
  }
}
