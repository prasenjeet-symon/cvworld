import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class EducationSection extends StatefulWidget {
  final String title;
  final String description;

  const EducationSection(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  getJSON() {}

  final CustomEducationSection _CustomEducationSection =
      CustomEducationSection();

  addNewItem() {
    _CustomEducationSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomEducationSection.removeItem(index);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _CustomEducationSection.dispose();
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
            margin: _CustomEducationSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _CustomEducationSection.item
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
                    _CustomEducationSection.item.isNotEmpty
                        ? const Text('Add one more education')
                        : const Text('Add education'),
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
class EducationItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomEducationItem customEducationItem;
  final int index;

  const EducationItem(
      {super.key,
      required this.onDelete,
      required this.customEducationItem,
      required this.index});

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
    widget.customEducationItem.city.controller.dispose();
    widget.customEducationItem.degree.controller.dispose();
    widget.customEducationItem.description.controller.dispose();
    widget.customEducationItem.endDate.controller.dispose();
    widget.customEducationItem.school.controller.dispose();
    widget.customEducationItem.startDate.controller.dispose();
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
      title: 'Education Item',
      onDelete: widget.onDelete,
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

/** 
 * 
 * 
 * 
 */
class CustomEducationItem {
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

  CustomEducationItem(
      {required this.school,
      required this.degree,
      required this.startDate,
      required this.endDate,
      required this.city,
      required this.description});

  generateCustomInputFields() {
    schoolField = CustomInputField(
        label: school.label,
        isRequired: school.isRequired,
        controller: school.controller,
        type: school.type);

    degreeField = CustomInputField(
        label: degree.label,
        isRequired: degree.isRequired,
        controller: degree.controller,
        type: degree.type);

    startDateField = CustomInputField(
        label: startDate.label,
        isRequired: startDate.isRequired,
        controller: startDate.controller,
        type: startDate.type);

    endDateField = CustomInputField(
        label: endDate.label,
        isRequired: endDate.isRequired,
        controller: endDate.controller,
        type: endDate.type);

    cityField = CustomInputField(
        label: city.label,
        isRequired: city.isRequired,
        controller: city.controller,
        type: city.type);

    descriptionField = CustomInputField(
        label: description.label,
        isRequired: description.isRequired,
        controller: description.controller,
        type: description.type);
  }
}

class CustomEducationSection {
  List<CustomEducationItem> item = [];
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
    item.add(CustomEducationItem(
      school: CustomInputType(
        'School',
        'school',
        true,
        _addController(),
        TextInputType.text,
      ),
      degree: CustomInputType(
        'Degree',
        'degree',
        true,
        _addController(),
        TextInputType.text,
      ),
      startDate: CustomInputType(
        'Start Date',
        'startDate',
        true,
        _addController(),
        TextInputType.datetime,
      ),
      endDate: CustomInputType(
        'End Date',
        'endDate',
        true,
        _addController(),
        TextInputType.datetime,
      ),
      city: CustomInputType(
        'City',
        'city',
        true,
        _addController(),
        TextInputType.text,
      ),
      description: CustomInputType(
        'Description',
        'description',
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
