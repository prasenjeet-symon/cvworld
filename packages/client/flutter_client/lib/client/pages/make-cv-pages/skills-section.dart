import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';
import 'package:flutter_client/client/utils.dart';

class SkillSection extends StatefulWidget {
  final String title;
  final String description;

  const SkillSection({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<SkillSection> createState() => SkillSectionState();
}

class SkillSectionState extends State<SkillSection> {
  List<Skills> getData() {
    return _CustomSkillSection.item
        .map((e) => {
              Skills(
                e.skill.controller.text,
                double.parse(e.level.controller.text),
              )
            })
        .expand((element) => element)
        .toList();
  }

  final CustomSkillSection _CustomSkillSection = CustomSkillSection();

  addNewItem() {
    _CustomSkillSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomSkillSection.removeItem(index);
    setState(() {});
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
            margin: _CustomSkillSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _CustomSkillSection.item
                  .asMap()
                  .map(
                    (i, e) => MapEntry(
                        i,
                        SkillItem(
                          customSkillsItem: e,
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
                    _CustomSkillSection.item.isNotEmpty
                        ? const Text('Add one more skill')
                        : const Text('Add Skills'),
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
class SkillItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomSkillItem customSkillsItem;
  final int index;

  const SkillItem(
      {super.key,
      required this.onDelete,
      required this.customSkillsItem,
      required this.index});

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem> {
  @override
  void initState() {
    super.initState();
    widget.customSkillsItem.generateCustomInputFields();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Skill Item',
      onDelete: widget.onDelete,
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.customSkillsItem.skillField,
                widget.customSkillsItem.levelField,
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
class CustomSkillItem {
  final CustomInputType skill;
  final CustomInputType level;

  late CustomInputField skillField;
  late CustomInputField levelField;

  CustomSkillItem({required this.skill, required this.level});

  generateCustomInputFields() {
    skillField = CustomInputField(
      label: skill.label,
      isRequired: skill.isRequired,
      controller: skill.controller,
      type: skill.type,
    );

    levelField = CustomInputField(
      label: level.label,
      isRequired: level.isRequired,
      controller: level.controller,
      type: level.type,
    );
  }
}

class CustomSkillSection {
  List<CustomSkillItem> item = [];
  final List<TextEditingController> _controllers = [];

  _addController() {
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
    item.add(CustomSkillItem(
      skill: CustomInputType(
        'Skill',
        'skill',
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
