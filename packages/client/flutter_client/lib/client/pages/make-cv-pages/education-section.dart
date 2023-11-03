// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/make-cv-pages/expandable-card.dart';
import 'package:cvworld/client/pages/make-cv-pages/side-by-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/types.dart';
import 'package:cvworld/client/utils.dart';
import 'package:rxdart/rxdart.dart';

class EducationSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const EducationSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<EducationSection> createState() => EducationSectionState();
}

class EducationSectionState extends State<EducationSection> {
  final CustomEducationSection _customEducationSection = CustomEducationSection();

  List<Education> getData() {
    return _customEducationSection.item
        .map((e) => {
              Education(
                e.school.controller.text,
                DateTime.parse(e.startDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : e.startDate.controller.text),
                DateTime.parse(e.endDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : e.endDate.controller.text),
                e.degree.controller.text,
                e.city.controller.text,
                e.description.controller.text,
              )
            })
        .expand((element) => element)
        .toList();
  }

  addNewItem() {
    _customEducationSection.addNewItem().then((value) => {setState(() {})});
  }

  removeItem(int index) {
    _customEducationSection.removeItem(index).then((value) => {setState(() {})});
  }

  @override
  void initState() {
    super.initState();

    _customEducationSection.resume = widget.resume;
    _customEducationSection.fetchEducation().then((value) => {setState(() {})});
    _customEducationSection.patchResume().then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _customEducationSection.dispose();
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
            margin: _customEducationSection.item.isNotEmpty ? const EdgeInsets.fromLTRB(0, 15, 0, 15) : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _customEducationSection.item
                  .asMap()
                  .map(
                    (i, e) => MapEntry(
                        i,
                        EducationItem(
                          customEducationItem: e,
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
                    _customEducationSection.item.isNotEmpty ? const Text('Add one more education') : const Text('Add education'),
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
class EducationItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomEducationItem customEducationItem;
  final int index;

  const EducationItem({super.key, required this.onDelete, required this.customEducationItem, required this.index});

  @override
  State<EducationItem> createState() => _EducationItemState();
}

class _EducationItemState extends State<EducationItem> {
  bool isExpanded = true;
  String heading = 'Education Item';

  setHeading() {
    if (mounted) {
      setState(() {
        heading = widget.customEducationItem.school.controller.text;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.customEducationItem.generateCustomInputFields();
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

  void deleteEducation(BuildContext context, int educationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this education?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and delete the education item
                widget.onDelete(educationId);
                Navigator.of(context).pop();
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
      title: 'Education Item',
      onDelete: (int index) => deleteEducation(context, index),
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.customEducationItem.schoolField,
                widget.customEducationItem.degreeField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customEducationItem.startDateField,
                widget.customEducationItem.endDateField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customEducationItem.cityField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customEducationItem.descriptionField,
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
class CustomEducationItem {
  int id;
  final CustomInputType school;
  final CustomInputType degree;
  final CustomInputType startDate;
  final CustomInputType endDate;
  final CustomInputType city;
  final CustomInputType description;

  late CustomInputField schoolField;
  late CustomInputField degreeField;
  late CustomInputField startDateField;
  late CustomInputField endDateField;
  late CustomInputField cityField;
  late CustomInputField descriptionField;

  BehaviorSubject<int> controller = BehaviorSubject();

  CustomEducationItem({
    required this.id,
    required this.school,
    required this.degree,
    required this.startDate,
    required this.endDate,
    required this.city,
    required this.description,
  });

  // listen for the changes
  Stream<int> listenForChanges() {
    school.controller.addListener(() {
      controller.add(id);
    });

    degree.controller.addListener(() {
      controller.add(id);
    });

    startDate.controller.addListener(() {
      controller.add(id);
    });

    endDate.controller.addListener(() {
      controller.add(id);
    });

    city.controller.addListener(() {
      controller.add(id);
    });

    description.controller.addListener(() {
      controller.add(id);
    });

    return controller.debounceTime(const Duration(milliseconds: Constants.debounceTime));
  }

  // dispose
  dispose() {
    controller.close();

    // remove the listener
    school.controller.removeListener(() {});
    degree.controller.removeListener(() {});
    startDate.controller.removeListener(() {});
    endDate.controller.removeListener(() {});
    city.controller.removeListener(() {});
    description.controller.removeListener(() {});

    school.controller.dispose();
    degree.controller.dispose();
    startDate.controller.dispose();
    endDate.controller.dispose();
    city.controller.dispose();
    description.controller.dispose();
  }

  generateCustomInputFields() {
    schoolField = CustomInputField(label: school.label, isRequired: school.isRequired, controller: school.controller, type: school.type);

    degreeField = CustomInputField(label: degree.label, isRequired: degree.isRequired, controller: degree.controller, type: degree.type);

    startDateField = CustomInputField(label: startDate.label, isRequired: startDate.isRequired, controller: startDate.controller, type: startDate.type);

    endDateField = CustomInputField(label: endDate.label, isRequired: endDate.isRequired, controller: endDate.controller, type: endDate.type);

    cityField = CustomInputField(label: city.label, isRequired: city.isRequired, controller: city.controller, type: city.type);

    descriptionField = CustomInputField(label: description.label, isRequired: description.isRequired, controller: description.controller, type: description.type);
  }
}

///
///
///
///
///
///
class CustomEducationSection {
  List<CustomEducationItem> item = [];
  final List<TextEditingController> _controllers = [];
  List<UserEducation> education = [];
  Resume? resume;

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  // patch the educations
  Future<void> patchResume() async {
    if (resume == null) return;
    var educationToPatch = resume!.education;

    for (var element in educationToPatch) {
      var schoolController = _addController();
      schoolController.text = element.school;

      var degreeController = _addController();
      degreeController.text = element.degree;

      var startDateController = _addController();
      startDateController.text = formatDateTime(element.startDate);

      var endDateController = _addController();
      endDateController.text = formatDateTime(element.endDate);

      var cityController = _addController();
      cityController.text = element.city;

      var descriptionController = _addController();
      descriptionController.text = element.description;

      var customEducationItem = CustomEducationItem(
        id: getId(),
        school: CustomInputType('School', 'school', true, schoolController, TextInputType.text),
        degree: CustomInputType('Degree', 'degree', true, degreeController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
        city: CustomInputType('City', 'city', true, cityController, TextInputType.text),
        description: CustomInputType('Description', 'description', true, descriptionController, TextInputType.text),
      );

      item.add(customEducationItem);
    }
  }

  // fetch education
  fetchEducation() async {
    if (!(resume == null)) return;

    var educationFetched = await DatabaseService().fetchUserEducations();
    if (educationFetched == null) return;
    education = educationFetched!;

    for (var element in education) {
      var schoolController = _addController();
      schoolController.text = element.school;

      var degreeController = _addController();
      degreeController.text = element.degree;

      var startDateController = _addController();
      startDateController.text = formatDateTime(element.startDate);

      var endDateController = _addController();
      endDateController.text = formatDateTime(element.endDate);

      var cityController = _addController();
      cityController.text = element.city;

      var descriptionController = _addController();
      descriptionController.text = element.description;

      var customEducationItem = CustomEducationItem(
        id: element.id,
        school: CustomInputType('School', 'school', true, schoolController, TextInputType.text),
        degree: CustomInputType('Degree', 'degree', true, degreeController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
        city: CustomInputType('City', 'city', true, cityController, TextInputType.text),
        description: CustomInputType('Description', 'description', true, descriptionController, TextInputType.text),
      );

      item.add(customEducationItem);

      // listen for the changes and update the item
      customEducationItem.listenForChanges().listen((event) {
        updateItem(event);
      });
    }
  }

  dispose() {
    for (var element in item) {
      element.dispose();
    }
  }

  // get the latest id
  int getId() {
    var id = 0;
    for (var element in item) {
      if (element.id > id) {
        id = element.id;
      }
    }

    return id + 1;
  }

  Future<void> addNewItem() async {
    var id = getId();

    var customEducationItem = CustomEducationItem(
      id: id,
      school: CustomInputType('School', 'school', true, _addController(), TextInputType.text),
      degree: CustomInputType('Degree', 'degree', true, _addController(), TextInputType.text),
      startDate: CustomInputType('Start Date', 'startDate', true, _addController(), TextInputType.datetime),
      endDate: CustomInputType('End Date', 'endDate', true, _addController(), TextInputType.datetime),
      city: CustomInputType('City', 'city', true, _addController(), TextInputType.text),
      description: CustomInputType('Description', 'description', true, _addController(), TextInputType.text),
    );

    if (resume == null) {
      // listen for the changes and update the item
      customEducationItem.listenForChanges().listen((event) {
        updateItem(event);
      });

      // add to the database
      var educationItemToAdd = UserEducation(
        customEducationItem.id,
        customEducationItem.school.controller.text,
        customEducationItem.startDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(customEducationItem.startDate.controller.text),
        customEducationItem.endDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(customEducationItem.endDate.controller.text),
        customEducationItem.degree.controller.text,
        customEducationItem.city.controller.text,
        customEducationItem.description.controller.text,
        DateTime.now(),
        DateTime.now(),
      );

      var addedItem = await DatabaseService().addUpdateUserEducation(educationItemToAdd);
      education.add(addedItem!);
      customEducationItem.id = addedItem.id;
      item.add(customEducationItem);
    } else {
      item.add(customEducationItem);
    }
  }

  Future<void> removeItem(int index) async {
    // remove locally
    var itemToRemove = item[index];
    itemToRemove.dispose();
    item.removeAt(index);

    if (resume == null) {
      var savedItemIndex = education.indexWhere((element) => element.id == itemToRemove.id);
      if (savedItemIndex != -1) {
        education.removeAt(savedItemIndex);
        await DatabaseService().deleteUserEducation(DeleteDocuments(itemToRemove.id));
      }
    }
  }

  // update the item
  Future<void> updateItem(int id) async {
    var changedItemIndex = item.indexWhere((element) => element.id == id);
    if (changedItemIndex == -1) return;
    var changedItem = item[changedItemIndex];

    var itemForUpdate = UserEducation(
      changedItem.id,
      changedItem.school.controller.text,
      changedItem.startDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(changedItem.startDate.controller.text),
      changedItem.endDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(changedItem.endDate.controller.text),
      changedItem.degree.controller.text,
      changedItem.city.controller.text,
      changedItem.description.controller.text,
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserEducation(itemForUpdate);
    var savedItemIndexChanged = education.indexWhere((element) => element.id == changedItem.id);

    if (savedItemIndexChanged != -1) {
      education[savedItemIndexChanged] = itemForUpdate;
    }
  }
}
