import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';
import 'package:flutter_client/client/utils.dart';

class EmploymentHistorySection extends StatefulWidget {
  final String title;
  final String description;

  const EmploymentHistorySection({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<EmploymentHistorySection> createState() =>
      EmploymentHistorySectionState();
}

class EmploymentHistorySectionState extends State<EmploymentHistorySection> {
  List<EmploymentHistory> getData() {
    return _CustomEmploymentHistory.item
        .map((e) => {
              EmploymentHistory(
                e.jobTitle.controller.text,
                e.employer.controller.text,
                DateTime.parse(e.startDate.controller.text),
                DateTime.parse(e.endDate.controller.text),
                e.city.controller.text,
                e.description.controller.text,
              )
            })
        .expand((element) => element)
        .toList();
  }

  final CustomEmploymentHistory _CustomEmploymentHistory =
      CustomEmploymentHistory();

  addNewItem() {
    _CustomEmploymentHistory.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomEmploymentHistory.removeItem(index);
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
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Column(
              children: _CustomEmploymentHistory.item
                  .asMap()
                  .map((key, e) => MapEntry(
                      key,
                      EmploymentHistoryItem(
                        customEmploymentHistoryItem: e,
                        onDelete: removeItem,
                        index: key,
                      )))
                  .values
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: TextButton(
                onPressed: addNewItem,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _CustomEmploymentHistory.item.isEmpty
                        ? const Text('Add employment history')
                        : const Text('Add one more employment history'),
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

class EmploymentHistoryItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomEmploymentHistoryItem customEmploymentHistoryItem;
  final int index;

  const EmploymentHistoryItem(
      {super.key,
      required this.onDelete,
      required this.customEmploymentHistoryItem,
      required this.index});

  @override
  State<EmploymentHistoryItem> createState() => _EmploymentHistoryItemState();
}

class _EmploymentHistoryItemState extends State<EmploymentHistoryItem> {
  @override
  void initState() {
    super.initState();
    widget.customEmploymentHistoryItem.generateCustomInputFields();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Employment History Item',
      onDelete: widget.onDelete,
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.customEmploymentHistoryItem.jobTitleField,
                widget.customEmploymentHistoryItem.employerField
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customEmploymentHistoryItem.startDateField,
                widget.customEmploymentHistoryItem.endDateField
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customEmploymentHistoryItem.cityField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customEmploymentHistoryItem.descriptionField,
              ].toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// For the employment history collection
class CustomEmploymentHistoryItem {
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

  CustomEmploymentHistoryItem(
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
    );
  }
}

class CustomEmploymentHistory {
  List<CustomEmploymentHistoryItem> item = [];
  final List<TextEditingController> _controllers = [];

  dispose() {
    for (var element in _controllers) {
      element.dispose();
    }
  }

  // add new controller
  _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  addNewItem() {
    item.add(CustomEmploymentHistoryItem(
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
