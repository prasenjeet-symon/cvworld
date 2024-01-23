// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/make-cv-pages/expandable-card.dart';
import 'package:cvworld/client/pages/make-cv-pages/side-by-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/types.dart';
import 'package:cvworld/client/utils.dart';
import 'package:rxdart/rxdart.dart';

class SkillSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const SkillSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<SkillSection> createState() => SkillSectionState();
}

class SkillSectionState extends State<SkillSection> {
  final CustomSkillSection _customSkillSection = CustomSkillSection();

  List<Skills> getData() {
    return _customSkillSection.item.map((e) => {Skills(e.skill.controller.text, double.parse(e.level.controller.text.isEmpty ? '0' : e.level.controller.text))}).expand((element) => element).toList();
  }

  addNewItem() {
    _customSkillSection.addNewItem().then((value) => {setState(() {})});
  }

  removeItem(int index) {
    _customSkillSection.removeItem(index).then((value) => {setState(() {})});
  }

  @override
  void initState() {
    super.initState();

    _customSkillSection.resume = widget.resume;
    _customSkillSection.fetchUserSkills().then((value) => {setState(() {})});
    _customSkillSection.patchResume().then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _customSkillSection.dispose();
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
            margin: _customSkillSection.item.isNotEmpty ? const EdgeInsets.fromLTRB(0, 15, 0, 15) : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _customSkillSection.item
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
                    _customSkillSection.item.isNotEmpty ? const Text('Add one more skill') : const Text('Add Skills'),
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
class SkillItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomSkillItem customSkillsItem;
  final int index;

  const SkillItem({super.key, required this.onDelete, required this.customSkillsItem, required this.index});

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem> {
  @override
  void initState() {
    super.initState();
    widget.customSkillsItem.generateCustomInputFields();
  }

  void deleteSkill(BuildContext context, int skillId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this skill item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and delete the skill item
                Navigator.of(context).pop();
                widget.onDelete(skillId);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and cancel deletion
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Skill Item',
      onDelete: (int id) => deleteSkill(context, id),
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

///
///
///
///
///
///
class CustomSkillItem {
  int id;
  final CustomInputType skill;
  final CustomInputType level;

  late CustomInputField skillField;
  late CustomInputField levelField;

  BehaviorSubject<int> controller = BehaviorSubject<int>();

  CustomSkillItem({required this.id, required this.skill, required this.level});

  // listen for the changes
  Stream<int> listenForChanges() {
    skill.controller.addListener(() {
      controller.add(id);
    });

    level.controller.addListener(() {
      controller.add(id);
    });

    return controller.debounceTime(const Duration(milliseconds: Constants.debounceTime));
  }

  // dispose
  dispose() {
    skillField.controller.dispose();
    levelField.controller.dispose();

    // remove listeners
    skillField.controller.removeListener(() {});
    levelField.controller.removeListener(() {});

    controller.close();
  }

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
  List<UserSkill> _userSkills = [];
  Resume? resume;

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
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

  // patch the resume
  Future<void> patchResume() async {
    if (resume == null) return;
    var skillsToPatch = resume!.skills;

    for (var element in skillsToPatch) {
      var skillController = _addController();
      skillController.text = element.skill;

      var levelController = _addController();
      levelController.text = element.level.toString();

      var itemToAdd = CustomSkillItem(
        id: getLatestId(),
        skill: CustomInputType('Skill', 'skill', true, skillController, TextInputType.text),
        level: CustomInputType('Level', 'level', true, levelController, TextInputType.text),
      );

      item.add(itemToAdd);
    }
  }

  // fetch user skills
  Future<void> fetchUserSkills() async {
    if (!(resume == null)) return;

    var fetchedUserSkills = await DatabaseService().fetchUserSkills();
    if (fetchedUserSkills == null) return;
    _userSkills = fetchedUserSkills;

    for (var element in _userSkills) {
      var skillController = _addController();
      skillController.text = element.skill;

      var levelController = _addController();
      levelController.text = element.level.toString();

      var itemToAdd = CustomSkillItem(
        id: element.id,
        skill: CustomInputType('Skill', 'skill', true, skillController, TextInputType.text),
        level: CustomInputType('Level', 'level', true, levelController, TextInputType.text),
      );

      item.add(itemToAdd);

      itemToAdd.listenForChanges().listen((event) {
        updateUserSkill(event);
      });
    }
  }

  // update the user skill given id
  Future<void> updateUserSkill(int id) async {
    var userSkillToUpdateIndex = item.indexWhere((element) => element.id == id);
    if (userSkillToUpdateIndex == -1) {
      return;
    }

    var userSkillToUpdate = item[userSkillToUpdateIndex];

    var userSkillForDatabase = UserSkill(
      userSkillToUpdate.id,
      userSkillToUpdate.skill.controller.text,
      userSkillToUpdate.level.controller.text.isEmpty ? 0 : double.parse(userSkillToUpdate.level.controller.text),
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserSkill(userSkillForDatabase);

    var localUserSkillIndex = _userSkills.indexWhere((element) => element.id == id);
    if (localUserSkillIndex != -1) {
      _userSkills[localUserSkillIndex] = userSkillForDatabase;
    }
  }

  Future<void> addNewItem() async {
    var id = getLatestId();

    var itemToAdd = CustomSkillItem(
      id: id,
      skill: CustomInputType('Skill', 'skill', true, _addController(), TextInputType.text),
      level: CustomInputType('Level', 'level', true, _addController(), TextInputType.text),
    );

    if (resume == null) {
      // add to database
      itemToAdd.listenForChanges().listen((event) {
        updateUserSkill(event);
      });

      var itemForDatabase = UserSkill(
        itemToAdd.id,
        itemToAdd.skill.controller.text,
        itemToAdd.level.controller.text.isEmpty ? 0 : double.parse(itemToAdd.level.controller.text),
        DateTime.now(),
        DateTime.now(),
      );

      var addedItem = await DatabaseService().addUpdateUserSkill(itemForDatabase);
      _userSkills.add(addedItem!);
      itemToAdd.id = addedItem.id;
      item.add(itemToAdd);
    } else {
      item.add(itemToAdd);
    }
  }

  Future<void> removeItem(int index) async {
    var itemToRemove = item[index];
    item.removeAt(index);
    itemToRemove.dispose();

    if (resume == null) {
      // also remove from database
      var itemToRemoveDatabaseIndex = _userSkills.indexWhere((element) => element.id == itemToRemove.id);
      if (itemToRemoveDatabaseIndex != -1) {
        _userSkills.removeAt(itemToRemoveDatabaseIndex);
        await DatabaseService().deleteUserSkill(DeleteDocuments(itemToRemove.id));
      }
    }
  }
}
