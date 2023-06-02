import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

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
      _EmploymentHistorySectionState();
}

class _EmploymentHistorySectionState extends State<EmploymentHistorySection> {
  getJSON() {}

  final CustomEmploymentHistory _EmploymentHistorySection =
      CustomEmploymentHistory();

  addNewItem() {
    _EmploymentHistorySection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _EmploymentHistorySection.removeItem(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(widget.title),
          ),
          Container(
            child: Text(widget.description),
          ),
          Container(
            child: Column(
              children: _EmploymentHistorySection.item
                  .map((e) =>
                      EmploymentItem(employmentItem: e, onDelete: removeItem))
                  .toList(),
            ),
          ),
          Container(
            child: Text('Button to add'),
          )
        ],
      ),
    );
  }
}

class EmploymentItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomEmploymentHistoryItem employmentItem;

  const EmploymentItem(
      {super.key, required this.onDelete, required this.employmentItem});

  @override
  State<EmploymentItem> createState() => _EmploymentItemState();
}

class _EmploymentItemState extends State<EmploymentItem> {
  @override
  void initState() {
    super.initState();
    widget.employmentItem.generateCustomInputFields();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
        title: widget.employmentItem.jobTitle.controller.text,
        onDelete: widget.onDelete,
        children: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SideBySideInputs(
                    inputFields: [
                  widget.employmentItem.jobTitleField,
                  widget.employmentItem.employerField
                ].toList()),
                SideBySideInputs(
                    inputFields: [
                  widget.employmentItem.startDateField,
                  widget.employmentItem.endDateField
                ].toList()),
                SideBySideInputs(
                    inputFields: [widget.employmentItem.cityField].toList()),
                SideBySideInputs(
                    inputFields: [
                  widget.employmentItem.descriptionField,
                ].toList()),
              ],
            )));
  }
}
