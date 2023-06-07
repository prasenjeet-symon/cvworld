import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class InternshipSection extends StatefulWidget {
  final String title;
  final String description;

  const InternshipSection(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<InternshipSection> createState() => _InternshipSectionState();
}

class _InternshipSectionState extends State<InternshipSection> {
  getJSON() {}

  final CustomInternshipSection _CustomInternshipSection =
      CustomInternshipSection();

  addNewItem() {
    _CustomInternshipSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomInternshipSection.removeItem(index);
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
            margin: _CustomInternshipSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _CustomInternshipSection.item
                  .asMap()
                  .map(
                    (i, e) => MapEntry(
                        i,
                        InternshipItem(
                          customInternshipItem: e,
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
                    _CustomInternshipSection.item.isNotEmpty
                        ? const Text('Add one more internship')
                        : const Text('Add internship'),
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
class InternshipItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomInternshipItem customInternshipItem;
  final int index;

  const InternshipItem(
      {super.key,
      required this.onDelete,
      required this.customInternshipItem,
      required this.index});

  @override
  State<InternshipItem> createState() => _InternshipItemState();
}

class _InternshipItemState extends State<InternshipItem> {
  @override
  void initState() {
    super.initState();
    widget.customInternshipItem.generateCustomInputFields();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Internship item',
      onDelete: widget.onDelete,
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.customInternshipItem.jobTitleField,
                widget.customInternshipItem.employerField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customInternshipItem.startDateField,
                widget.customInternshipItem.endDateField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customInternshipItem.cityField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customInternshipItem.descriptionField,
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
class CustomInternshipItem {
  final CustomInputType jobTitle;
  final CustomInputType employer;
  final CustomInputType startDate;
  final CustomInputType endDate;
  final CustomInputType city;
  final CustomInputType description;

  late CustomInputField jobTitleField;
  late CustomInputField employerField;
  late CustomInputField startDateField;
  late CustomInputField endDateField;
  late CustomInputField cityField;
  late CustomInputField descriptionField;

  CustomInternshipItem(
      {required this.jobTitle,
      required this.employer,
      required this.startDate,
      required this.endDate,
      required this.city,
      required this.description});

  generateCustomInputFields() {
    jobTitleField = CustomInputField(
      label: jobTitle.label,
      isRequired: jobTitle.isRequired,
      controller: jobTitle.controller,
      type: jobTitle.type,
    );

    employerField = CustomInputField(
      label: employer.label,
      isRequired: employer.isRequired,
      controller: employer.controller,
      type: employer.type,
    );

    startDateField = CustomInputField(
      label: startDate.label,
      isRequired: startDate.isRequired,
      controller: startDate.controller,
      type: startDate.type,
    );

    endDateField = CustomInputField(
      label: endDate.label,
      isRequired: endDate.isRequired,
      controller: endDate.controller,
      type: endDate.type,
    );

    cityField = CustomInputField(
      label: city.label,
      isRequired: city.isRequired,
      controller: city.controller,
      type: city.type,
    );

    descriptionField = CustomInputField(
      label: description.label,
      isRequired: description.isRequired,
      controller: description.controller,
      type: description.type,
      isTextArea: true,
    );
  }
}

class CustomInternshipSection {
  List<CustomInternshipItem> item = [];
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
    item.add(CustomInternshipItem(
      jobTitle: CustomInputType(
        'Job Title',
        'jobTitle',
        true,
        _addController(),
        TextInputType.text,
      ),
      employer: CustomInputType(
        'Employer',
        'employer',
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
