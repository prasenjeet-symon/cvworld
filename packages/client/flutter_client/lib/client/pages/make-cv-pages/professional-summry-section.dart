import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class ProfessionalSummary extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const ProfessionalSummary({
    Key? key,
    required this.title,
    required this.description,
    this.resume,
  }) : super(key: key);

  @override
  State<ProfessionalSummary> createState() => ProfessionalSummaryState();
}

class ProfessionalSummaryState extends State<ProfessionalSummary> {
  final TextEditingController _controller = TextEditingController();
  CustomInputField? textEditor;
  UserProfessionalSummary? professionalSummary;
  BehaviorSubject<String> controller = BehaviorSubject();

  getData() {
    return {'profile': _controller.text};
  }

  @override
  void initState() {
    super.initState();

    final CustomInputType textEditorType = CustomInputType(
      'Summery',
      'professionalSummery',
      true,
      _controller,
      TextInputType.multiline,
    );

    textEditor = CustomInputField(
      label: textEditorType.label,
      isRequired: textEditorType.isRequired,
      controller: textEditorType.controller,
      type: textEditorType.type,
      isTextArea: true,
    );

    // fetch professional summary
    fetchProfessionalSummary().then((value) => {setState(() {})});
    // patch the resume
    patchResume().then((value) => {setState(() {})});

    // listen for the changes and update professional summary
    if (widget.resume.isNull) {
      textEditor?.controller.addListener(() {
        controller.add(textEditor?.controller.text ?? '');
      });

      controller.debounceTime(const Duration(milliseconds: 1000)).listen(
        (value) {
          updateProfessionalSummary();
        },
      );
    }
  }

  // patch the resume
  Future<void> patchResume() async {
    if (widget.resume.isNull) return;
    _controller.text = widget.resume!.profession;
  }

  // fetch professional summary
  Future<void> fetchProfessionalSummary() async {
    if (widget.resume.isNull) {
      var fetchedProfessionalSummary =
          await DatabaseService().fetchUserProfessionalSummary();
      if (fetchedProfessionalSummary.isNull) return;

      professionalSummary = fetchedProfessionalSummary;
      // patch the data
      _controller.text = professionalSummary!.profile;
    }
  }

  // update the professional summary
  Future<void> updateProfessionalSummary() async {
    if (widget.resume.isNull) {
      var updatedProfessionalSummary = UserProfessionalSummary(
        professionalSummary.isNull ? 1 : professionalSummary!.id,
        _controller.text,
        DateTime.now(),
        DateTime.now(),
      );

      await DatabaseService()
          .addUpdateUserProfessionalSummary(updatedProfessionalSummary);

      professionalSummary = updatedProfessionalSummary;

      Fluttertoast.showToast(
        msg: 'Professional summary updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
