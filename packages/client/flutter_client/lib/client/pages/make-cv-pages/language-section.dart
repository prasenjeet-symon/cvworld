import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class LanguageSection extends StatefulWidget {
  final String title;
  final String description;

  const LanguageSection(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<LanguageSection> createState() => _LanguageSectionState();
}

class _LanguageSectionState extends State<LanguageSection> {
  getJSON() {}

  final CustomLanguageSection _CustomLanguageSection = CustomLanguageSection();

  addNewItem() {
    _CustomLanguageSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomLanguageSection.removeItem(index);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _CustomLanguageSection.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            margin: _CustomLanguageSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _CustomLanguageSection.item
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
                    _CustomLanguageSection.item.isNotEmpty
                        ? const Text('Add one more language')
                        : const Text('Add language'),
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

/** 
 * 
 * 
 * 
 * 
 */
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

  @override
  void dispose() {
    super.dispose();
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

/** 
 * 
 * 
 * 
 */
class CustomLanguageItem {
  final CustomInputType language;
  final CustomInputType level;

  late CustomInputField languageField;
  late CustomInputField levelField;

  CustomLanguageItem({required this.language, required this.level});

  generateCustomInputFields() {
    languageField = CustomInputField(
        label: language.label,
        isRequired: language.isRequired,
        controller: language.controller,
        type: language.type);

    levelField = CustomInputField(
        label: level.label,
        isRequired: level.isRequired,
        controller: level.controller,
        type: level.type);
  }
}

class CustomLanguageSection {
  List<CustomLanguageItem> item = [];
  final List<TextEditingController> _controllers = [];

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
  }

  addNewItem() {
    item.add(CustomLanguageItem(
      language: CustomInputType(
        'Language',
        'language',
        true,
        _addController(),
        TextInputType.text,
      ),
      level: CustomInputType(
        'Level',
        'level',
        true,
        _addController(),
        TextInputType.text,
      ),
    ));
  }

  void removeItem(int index) {
    item.removeAt(index);
  }
}
