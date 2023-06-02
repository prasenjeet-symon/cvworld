import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';

class CustomInputType {
  final String label;
  final String jsonKey;
  final bool isRequired;
  final TextInputType type;
  final TextEditingController controller;

  CustomInputType(
    this.label,
    this.jsonKey,
    this.isRequired,
    this.controller,
    this.type,
  );
}

typedef DeleteFunction = void Function(int index);
typedef GetJSONFunction = String Function();

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
        type: jobTitle.type);

    employerField = CustomInputField(
        label: employer.label,
        isRequired: employer.isRequired,
        controller: employer.controller,
        type: employer.type);

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
          'Job Title', 'jobTitle', true, _addController(), TextInputType.text),
      employer: CustomInputType(
          'Employer', 'employer', true, _addController(), TextInputType.text),
      startDate: CustomInputType('Start Date', 'startDate', true,
          _addController(), TextInputType.datetime),
      endDate: CustomInputType('End Date', 'endDate', true, _addController(),
          TextInputType.datetime),
      city: CustomInputType(
          'City', 'city', true, _addController(), TextInputType.text),
      description: CustomInputType('Description', 'description', true,
          _addController(), TextInputType.text),
    ));
  }

  void removeItem(int index) {
    item.removeAt(index);
  }
}
