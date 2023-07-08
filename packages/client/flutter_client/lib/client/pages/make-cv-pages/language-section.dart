import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class LanguageSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const LanguageSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<LanguageSection> createState() => LanguageSectionState();
}

class LanguageSectionState extends State<LanguageSection> {
  final CustomLanguageSection _customLanguageSection = CustomLanguageSection();

  List<Languages> getData() {
    return _customLanguageSection.item.map((e) => {Languages(e.language.controller.text, double.parse(e.level.controller.text.isEmpty ? '0' : e.level.controller.text))}).expand((element) => element).toList();
  }

  addNewItem() {
    _customLanguageSection.addNewItem().then((value) => {setState(() {})});
  }

  removeItem(int index) {
    _customLanguageSection.removeItem(index).then((value) => {setState(() {})});
  }

  @override
  void initState() {
    super.initState();

    _customLanguageSection.resume = widget.resume;
    _customLanguageSection.fetchUserLanguages().then((value) => {setState(() {})});
    _customLanguageSection.patchResume().then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _customLanguageSection.dispose();
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
            margin: _customLanguageSection.item.isNotEmpty ? const EdgeInsets.fromLTRB(0, 15, 0, 15) : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _customLanguageSection.item
                  .asMap()
                  .map(
                    (i, e) => MapEntry(
                        i,
                        LanguageItem(
                          customLanguageItem: e,
                          onDelete: removeItem,
                          index: i,
                        )),
                  )
                  .values
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: TextButton(
                onPressed: () => addNewItem(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _customLanguageSection.item.isNotEmpty ? const Text('Add one more language') : const Text('Add language'),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: const Icon(Icons.add),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

///
///
///
///
///
///
///
class LanguageItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomLanguageItem customLanguageItem;
  final int index;

  const LanguageItem({
    super.key,
    required this.onDelete,
    required this.customLanguageItem,
    required this.index,
  });

  @override
  State<LanguageItem> createState() => _LanguageItemState();
}

class _LanguageItemState extends State<LanguageItem> {
  bool isExpanded = true;
  String heading = 'Language Item';

  @override
  void initState() {
    super.initState();
    widget.customLanguageItem.generateCustomInputFields();
  }

  toggleIsExpanded() {
    if (mounted) {
      setState(() {
        isExpanded = !isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Language Item',
      onDelete: widget.onDelete,
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.customLanguageItem.languageField,
                widget.customLanguageItem.levelField,
              ].toList(),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
///
///
///
class CustomLanguageItem {
  final CustomInputType language;
  final CustomInputType level;
  int id;

  late CustomInputField languageField;
  late CustomInputField levelField;

  // behavior subject
  final BehaviorSubject<int> controller = BehaviorSubject<int>();

  CustomLanguageItem({
    required this.language,
    required this.level,
    required this.id,
  });

  // listen for the changes
  Stream<int> listenForChanges() {
    language.controller.addListener(() {
      controller.add(id);
    });

    level.controller.addListener(() {
      controller.add(id);
    });

    return controller.debounceTime(const Duration(milliseconds: Constants.debounceTime));
  }

  // dispose
  dispose() {
    // remove the listener
    languageField.controller.removeListener(() {});
    levelField.controller.removeListener(() {});
    // dispose controller
    controller.close();

    languageField.controller.dispose();
    levelField.controller.dispose();
  }

  generateCustomInputFields() {
    languageField = CustomInputField(label: language.label, isRequired: language.isRequired, controller: language.controller, type: language.type);

    levelField = CustomInputField(label: level.label, isRequired: level.isRequired, controller: level.controller, type: level.type);
  }
}

class CustomLanguageSection {
  List<CustomLanguageItem> item = [];
  final List<TextEditingController> _controllers = [];
  List<UserLanguage> _userLanguages = [];
  Resume? resume;

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  // patch the resume
  Future<void> patchResume() async {
    if (resume.isNull) return;
    var resumeToPatch = resume!.languages;

    for (var language in resumeToPatch) {
      var languageController = _addController();
      languageController.text = language.language;

      var levelController = _addController();
      levelController.text = language.level.toString();

      var itemToAdd = CustomLanguageItem(
        id: getLatestId(),
        language: CustomInputType('Language', 'language', true, languageController, TextInputType.text),
        level: CustomInputType('Level', 'level', true, levelController, TextInputType.text),
      );

      item.add(itemToAdd);
    }
  }

  dispose() {
    for (var element in item) {
      element.dispose();
    }
  }

  // get the latest id
  int getLatestId() {
    int id = 0;
    for (var element in item) {
      if (element.id > id) {
        id = element.id;
      }
    }

    return id + 1;
  }

  // Fetch all the items from the database
  Future<void> fetchUserLanguages() async {
    if (!resume.isNull) return;

    var fetchedLanguages = await DatabaseService().fetchUserLanguages();
    if (fetchedLanguages.isNull) return;
    _userLanguages = fetchedLanguages!;

    for (var language in _userLanguages) {
      // language controller and patch the value
      var languageController = _addController();
      languageController.text = language.language;

      // level controller and patch the value
      var levelController = _addController();
      levelController.text = language.level.toString();

      var itemToAdd = CustomLanguageItem(
        id: language.id,
        language: CustomInputType('Language', 'language', true, languageController, TextInputType.text),
        level: CustomInputType('Level', 'level', true, levelController, TextInputType.text),
      );

      item.add(itemToAdd);

      itemToAdd.listenForChanges().listen((event) {
        // update the item
        updateItem(event);
      });
    }
  }

  // Delete the item given index
  Future<void> removeItem(int index) async {
    // remove locally first
    var itemToRemove = item[index];
    item.removeAt(index);
    itemToRemove.dispose();

    // remove from database
    if (resume.isNull) {
      var itemToRemoveDatabaseIndex = _userLanguages.indexWhere((element) => element.id == itemToRemove.id);
      if (itemToRemoveDatabaseIndex != -1) {
        _userLanguages.removeAt(itemToRemoveDatabaseIndex);
        await DatabaseService().deleteUserLanguage(DeleteDocuments(itemToRemove.id));
      }
    }

    Fluttertoast.showToast(msg: 'Language removed', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  // update the item given id
  Future<void> updateItem(int id) async {
    // update will happen if no resume is provided
    var itemToUpdateIndex = item.indexWhere((element) => element.id == id);
    if (itemToUpdateIndex == -1) return;

    var updateItem = item[itemToUpdateIndex];

    var itemForDatabaseUpdated = UserLanguage(
      updateItem.id,
      updateItem.language.controller.text,
      updateItem.level.controller.text.isEmpty ? 0 : double.parse(updateItem.level.controller.text),
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserLanguage(itemForDatabaseUpdated);

    Fluttertoast.showToast(msg: 'Language updated', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
  }

  // Add new item
  Future<void> addNewItem() async {
    var id = getLatestId();

    var itemToAdd = CustomLanguageItem(
      id: id,
      language: CustomInputType('Language', 'language', true, _addController(), TextInputType.text),
      level: CustomInputType('Level', 'level', true, _addController(), TextInputType.text),
    );

    if (resume.isNull) {
      itemToAdd.listenForChanges().listen((event) {
        // update the item
        updateItem(event);
      });

      var itemForDatabase = UserLanguage(
        itemToAdd.id,
        itemToAdd.language.controller.text,
        itemToAdd.level.controller.text.isEmpty ? 0 : double.parse(itemToAdd.level.controller.text),
        DateTime.now(),
        DateTime.now(),
      );

      var addedItem = await DatabaseService().addUpdateUserLanguage(itemForDatabase);
      _userLanguages.add(addedItem!);
      itemToAdd.id = addedItem.id;
      item.add(itemToAdd);
    } else {
      item.add(itemToAdd);
    }

    Fluttertoast.showToast(msg: 'Language added', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
  }
}
