import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class HobbiesSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const HobbiesSection({
    Key? key,
    required this.title,
    required this.description,
    this.resume,
  }) : super(key: key);

  @override
  State<HobbiesSection> createState() => HobbiesSectionState();
}

class HobbiesSectionState extends State<HobbiesSection> {
  final TextEditingController _controller = TextEditingController();
  late final CustomInputField textEditor;
  BehaviorSubject<String> controller = BehaviorSubject();

  UserHobby? hobby;

  String getData() {
    return _controller.text;
  }

  // fetch the hobby
  Future<void> fetchHobby() async {
    if (!widget.resume.isNull) {
      return;
    }

    var fetchedHobby = await DatabaseService().fetchUserHobby();
    if (fetchedHobby.isNull) return;

    hobby = fetchedHobby;

    // patch the hobby
    _controller.text = fetchedHobby!.hobby;
  }

  // update the hobby
  Future<void> updateHobby() async {
    var updatedHobby = UserHobby(
      hobby.isNull ? 1 : hobby!.id,
      _controller.text,
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserHobby(updatedHobby);

    Fluttertoast.showToast(
      msg: "Hobby updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green.withOpacity(0.8),
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();

    final CustomInputType textEditorType = CustomInputType(
      'Hobbies',
      'hobbies',
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

    // listen for the changes and update the database
    if (widget.resume.isNull) {
      textEditor.controller.addListener(() {
        controller.add(textEditor.controller.text);
      });

      controller
          .debounceTime(const Duration(milliseconds: Constants.debounceTime))
          .listen((value) {
        updateHobby();
      });
    }

    // fetch the hobby
    fetchHobby().then((value) => {setState(() {})});
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
