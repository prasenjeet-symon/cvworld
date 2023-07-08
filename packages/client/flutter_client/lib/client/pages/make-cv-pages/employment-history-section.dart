// ignore: file_names
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

class EmploymentHistorySection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const EmploymentHistorySection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<EmploymentHistorySection> createState() => EmploymentHistorySectionState();
}

class EmploymentHistorySectionState extends State<EmploymentHistorySection> {
  final CustomEmploymentHistory _customEmploymentHistory = CustomEmploymentHistory();

  List<EmploymentHistory> getData() {
    return _customEmploymentHistory.item
        .map((e) => {
              EmploymentHistory(
                e.jobTitle.controller.text,
                e.employer.controller.text,
                DateTime.parse(e.startDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : e.startDate.controller.text),
                DateTime.parse(e.endDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : e.endDate.controller.text),
                e.city.controller.text,
                e.description.controller.text,
              )
            })
        .expand((element) => element)
        .toList();
  }

  addNewItem() {
    _customEmploymentHistory.addNewItem().then((value) => {setState(() {})});
  }

  removeItem(int index) {
    _customEmploymentHistory.removeItem(index).then((value) => {setState(() {})});
  }

  @override
  void initState() {
    super.initState();

    _customEmploymentHistory.resume = widget.resume;
    _customEmploymentHistory.fetchEmploymentHistory().then((value) => {setState(() {})});
    _customEmploymentHistory.patchResume().then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _customEmploymentHistory.dispose();
    super.dispose();
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
              children: _customEmploymentHistory.item
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
                    _customEmploymentHistory.item.isEmpty ? const Text('Add employment history') : const Text('Add one more employment history'),
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

  const EmploymentHistoryItem({super.key, required this.onDelete, required this.customEmploymentHistoryItem, required this.index});

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
              inputFields: [widget.customEmploymentHistoryItem.jobTitleField, widget.customEmploymentHistoryItem.employerField].toList(),
            ),
            SideBySideInputs(
              inputFields: [widget.customEmploymentHistoryItem.startDateField, widget.customEmploymentHistoryItem.endDateField].toList(),
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
  int id;
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

  BehaviorSubject<int> controller = BehaviorSubject();

  CustomEmploymentHistoryItem({
    required this.id,
    required this.jobTitle,
    required this.employer,
    required this.startDate,
    required this.endDate,
    required this.city,
    required this.description,
  });

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

  // listen for the changes
  Stream<int> listenForChanges() {
    jobTitle.controller.addListener(() {
      controller.add(id);
    });

    employer.controller.addListener(() {
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
    // remove the listener
    jobTitleField.controller.removeListener(() {});
    employerField.controller.removeListener(() {});
    startDateField.controller.removeListener(() {});
    endDateField.controller.removeListener(() {});
    cityField.controller.removeListener(() {});
    descriptionField.controller.removeListener(() {});

    jobTitleField.controller.dispose();
    employerField.controller.dispose();
    startDateField.controller.dispose();
    endDateField.controller.dispose();
    cityField.controller.dispose();
    descriptionField.controller.dispose();

    controller.close();
  }
}

class CustomEmploymentHistory {
  List<CustomEmploymentHistoryItem> item = [];
  final List<TextEditingController> _controllers = [];
  List<UserEmployment> employment = [];
  Resume? resume;

  // patch the resume
  Future<void> patchResume() async {
    if (resume.isNull) return;
    var employmentHistoryToPatch = resume!.employmentHistory;

    for (var element in employmentHistoryToPatch) {
      var jobController = _addController();
      jobController.text = element.job;

      var employerController = _addController();
      employerController.text = element.employer;

      var startDateController = _addController();
      startDateController.text = element.startDate.toIso8601String();

      var endDateController = _addController();
      endDateController.text = element.endDate.toIso8601String();

      var cityController = _addController();
      cityController.text = element.city;

      var descriptionController = _addController();
      descriptionController.text = element.description;

      var itemToAdd = CustomEmploymentHistoryItem(
        id: getLatestId(),
        jobTitle: CustomInputType('Job Title', 'jobTitle', true, jobController, TextInputType.text),
        employer: CustomInputType('Employer', 'employer', true, employerController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
        city: CustomInputType('City', 'city', true, cityController, TextInputType.text),
        description: CustomInputType('Description', 'description', true, descriptionController, TextInputType.text),
      );

      item.add(itemToAdd);
    }
  }

  // fetch employment history
  Future<void> fetchEmploymentHistory() async {
    if (!resume.isNull) return;
    var fetchedEmploymentHistory = await DatabaseService().fetchUserEmploymentHistories();
    if (fetchedEmploymentHistory.isNull) return;
    employment = fetchedEmploymentHistory!;

    for (var element in employment) {
      var jobController = _addController();
      jobController.text = element.job;

      var employerController = _addController();
      employerController.text = element.employer;

      var startDateController = _addController();
      startDateController.text = element.startDate.toIso8601String();

      var endDateController = _addController();
      endDateController.text = element.endDate.toIso8601String();

      var cityController = _addController();
      cityController.text = element.city;

      var descriptionController = _addController();
      descriptionController.text = element.description;

      var itemToAdd = CustomEmploymentHistoryItem(
        id: element.id,
        jobTitle: CustomInputType('Job Title', 'jobTitle', true, jobController, TextInputType.text),
        employer: CustomInputType('Employer', 'employer', true, employerController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
        city: CustomInputType('City', 'city', true, cityController, TextInputType.text),
        description: CustomInputType('Description', 'description', true, descriptionController, TextInputType.text),
      );

      item.add(itemToAdd);

      itemToAdd.listenForChanges().listen((event) {
        updateEmploymentHistory(event);
      });
    }
  }

  void dispose() {
    for (var element in item) {
      element.dispose();
    }
  }

  // add new controller
  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
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

  Future<void> addNewItem() async {
    var id = getLatestId();

    var itemToAdd = CustomEmploymentHistoryItem(
      id: id,
      jobTitle: CustomInputType('Job Title', 'jobTitle', true, _addController(), TextInputType.text),
      employer: CustomInputType('Employer', 'employer', true, _addController(), TextInputType.text),
      startDate: CustomInputType('Start Date', 'startDate', true, _addController(), TextInputType.datetime),
      endDate: CustomInputType('End Date', 'endDate', true, _addController(), TextInputType.datetime),
      city: CustomInputType('City', 'city', true, _addController(), TextInputType.text),
      description: CustomInputType('Description', 'description', true, _addController(), TextInputType.text),
    );

    if (resume.isNull) {
      itemToAdd.listenForChanges().listen((event) {
        updateEmploymentHistory(event);
      });

      // save to database
      var databaseItem = UserEmployment(
        itemToAdd.id,
        itemToAdd.jobTitle.controller.text,
        itemToAdd.employer.controller.text,
        itemToAdd.startDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(itemToAdd.startDate.controller.text),
        itemToAdd.endDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(itemToAdd.endDate.controller.text),
        itemToAdd.city.controller.text,
        itemToAdd.description.controller.text,
        DateTime.now(),
        DateTime.now(),
      );

      var addedItem = await DatabaseService().addUpdateUserEmploymentHistory(databaseItem);
      employment.add(addedItem!);
      itemToAdd.id = addedItem.id;
      item.add(itemToAdd);
    } else {
      item.add(itemToAdd);
    }

    Fluttertoast.showToast(toastLength: Toast.LENGTH_SHORT, msg: 'Employment history added.', gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white);
  }

  Future<void> removeItem(int index) async {
    // remove locally
    var itemToRemove = item[index];
    itemToRemove.dispose();
    item.removeAt(index);

    if (resume.isNull) {
      var databaseItemIndex = employment.indexWhere((element) => element.id == itemToRemove.id);
      if (databaseItemIndex != -1) {
        employment.removeAt(databaseItemIndex);
        await DatabaseService().deleteUserEmploymentHistory(DeleteDocuments(itemToRemove.id));
      }
    }

    Fluttertoast.showToast(toastLength: Toast.LENGTH_SHORT, msg: 'Employment history removed.', gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white);
  }

  // update the employment history
  Future<void> updateEmploymentHistory(int id) async {
    var itemToUpdateIndex = item.indexWhere((element) => element.id == id);
    if (itemToUpdateIndex == -1) {
      return;
    }

    var itemToUpdate = item[itemToUpdateIndex];

    var itemForDatabase = UserEmployment(
      itemToUpdate.id,
      itemToUpdate.jobTitle.controller.text,
      itemToUpdate.employer.controller.text,
      itemToUpdate.startDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(itemToUpdate.startDate.controller.text),
      itemToUpdate.endDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(itemToUpdate.endDate.controller.text),
      itemToUpdate.city.controller.text,
      itemToUpdate.description.controller.text,
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserEmploymentHistory(itemForDatabase);
    var databaseItemIndex = employment.indexWhere((element) => element.id == itemToUpdate.id);
    if (databaseItemIndex != -1) {
      employment[databaseItemIndex] = itemForDatabase;
    }

    Fluttertoast.showToast(toastLength: Toast.LENGTH_SHORT, msg: 'Employment history updated.', gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white);
  }
}
