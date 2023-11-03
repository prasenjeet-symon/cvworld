// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/types.dart';
import 'package:cvworld/client/utils.dart';
import 'package:rxdart/rxdart.dart';

class HobbiesSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const HobbiesSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

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

  // patch the resume
  Future<void> patchResume() async {
    if (widget.resume == null) return;

    var hobbyToPatch = widget.resume!.hobbies;
    _controller.text = hobbyToPatch;
  }

  // fetch the hobby
  Future<void> fetchHobby() async {
    if (!(widget.resume == null)) return;

    var fetchedHobby = await DatabaseService().fetchUserHobby();
    if (fetchedHobby == null) return;

    hobby = fetchedHobby;

    // patch the hobby
    _controller.text = fetchedHobby!.hobby;
  }

  // update the hobby
  Future<void> updateHobby() async {
    var updatedHobby = UserHobby(hobby == null ? 1 : hobby!.id, _controller.text, DateTime.now(), DateTime.now());
    await DatabaseService().addUpdateUserHobby(updatedHobby);
  }

  @override
  void initState() {
    super.initState();

    final CustomInputType textEditorType = CustomInputType('Hobbies', 'hobbies', true, _controller, TextInputType.multiline);
    textEditor = CustomInputField(label: textEditorType.label, isRequired: textEditorType.isRequired, controller: textEditorType.controller, type: textEditorType.type, isTextArea: true);

    // listen for the changes and update the database
    if (widget.resume == null) {
      textEditor.controller.addListener(() {
        controller.add(textEditor.controller.text);
      });

      controller.debounceTime(const Duration(milliseconds: Constants.debounceTime)).listen((value) {
        updateHobby();
      });
    }

    // fetch the hobby
    fetchHobby().then((value) => {setState(() {})});
    // patch the resume
    patchResume().then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
