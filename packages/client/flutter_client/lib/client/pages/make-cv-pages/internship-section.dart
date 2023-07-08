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

class InternshipSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const InternshipSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<InternshipSection> createState() => InternshipSectionState();
}

class InternshipSectionState extends State<InternshipSection> {
  final CustomInternshipSection _customInternshipSection = CustomInternshipSection();

  List<Internship> getData() {
    return _customInternshipSection.item
        .map((element) => {
              Internship(
                element.jobTitle.controller.text,
                element.employer.controller.text,
                DateTime.parse(element.startDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : element.startDate.controller.text),
                DateTime.parse(element.endDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : element.endDate.controller.text),
                element.city.controller.text,
                element.description.controller.text,
              )
            })
        .expand((element) => element)
        .toList();
  }

  addNewItem() {
    _customInternshipSection.addNewItem().then((value) => {setState(() {})});
  }

  removeItem(int index) {
    _customInternshipSection.removeItem(index).then((value) => {setState(() {})});
  }

  @override
  void initState() {
    super.initState();

    _customInternshipSection.resume = widget.resume;
    _customInternshipSection.fetchInternships().then((value) => {setState(() {})});
    _customInternshipSection.patchResume().then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _customInternshipSection.dispose();
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
            margin: _customInternshipSection.item.isNotEmpty ? const EdgeInsets.fromLTRB(0, 15, 0, 15) : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _customInternshipSection.item
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
                    _customInternshipSection.item.isNotEmpty ? const Text('Add one more internship') : const Text('Add internship'),
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
///
///
class InternshipItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomInternshipItem customInternshipItem;
  final int index;

  const InternshipItem({super.key, required this.onDelete, required this.customInternshipItem, required this.index});

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

///
///
///
///
///
///
class CustomInternshipItem {
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

  // behavior subject
  BehaviorSubject<int> controller = BehaviorSubject();

  CustomInternshipItem({
    required this.id,
    required this.jobTitle,
    required this.employer,
    required this.startDate,
    required this.endDate,
    required this.city,
    required this.description,
  });

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
  void dispose() {
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

///
///
///
///
///
///
class CustomInternshipSection {
  List<CustomInternshipItem> item = [];
  final List<TextEditingController> _controllers = [];
  List<UserInternship> _userInternships = [];
  Resume? resume;

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  // patch the resume
  Future<void> patchResume() async {
    if (resume.isNull) return;
    var internshipToPatch = resume!.internship;

    for (var internship in internshipToPatch) {
      var jobController = _addController();
      jobController.text = internship.job;

      var employerController = _addController();
      employerController.text = internship.employer;

      var startDateController = _addController();
      startDateController.text = internship.startDate.toIso8601String();

      var endDateController = _addController();
      endDateController.text = internship.endDate.toIso8601String();

      var cityController = _addController();
      cityController.text = internship.city;

      var descriptionController = _addController();
      descriptionController.text = internship.description;

      var itemToAdd = CustomInternshipItem(
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

  // fetch the internship from the server and path it
  Future<void> fetchInternships() async {
    if (!resume.isNull) return;

    var fetchedInternship = await DatabaseService().fetchUserInternships();
    if (fetchedInternship.isNull) return;
    _userInternships = fetchedInternship!;

    // loop internships
    for (var internship in _userInternships) {
      var jobController = _addController();
      jobController.text = internship.job;

      var employerController = _addController();
      employerController.text = internship.employer;

      var startDateController = _addController();
      startDateController.text = internship.startDate.toIso8601String();

      var endDateController = _addController();
      endDateController.text = internship.endDate.toIso8601String();

      var cityController = _addController();
      cityController.text = internship.city;

      var descriptionController = _addController();
      descriptionController.text = internship.description;

      var databaseItem = CustomInternshipItem(
        id: internship.id,
        jobTitle: CustomInputType('Job Title', 'jobTitle', true, jobController, TextInputType.text),
        employer: CustomInputType('Employer', 'employer', true, employerController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
        city: CustomInputType('City', 'city', true, cityController, TextInputType.text),
        description: CustomInputType('Description', 'description', true, descriptionController, TextInputType.text),
      );

      item.add(databaseItem);

      databaseItem.listenForChanges().listen((event) {
        updateInternship(event);
      });
    }
  }

  // Update the internship given the id
  Future<void> updateInternship(int id) async {
    var itemToUpdateIndex = item.indexWhere((element) => element.id == id);
    if (itemToUpdateIndex == -1) {
      return;
    }

    var itemToUpdate = item[itemToUpdateIndex];

    var updatedItemForDatabase = UserInternship(
      itemToUpdate.id,
      itemToUpdate.jobTitleField.controller.text,
      itemToUpdate.employerField.controller.text,
      itemToUpdate.startDateField.controller.text.isEmpty ? DateTime.now() : DateTime.parse(itemToUpdate.startDateField.controller.text),
      itemToUpdate.endDateField.controller.text.isEmpty ? DateTime.now() : DateTime.parse(itemToUpdate.endDateField.controller.text),
      itemToUpdate.cityField.controller.text,
      itemToUpdate.descriptionField.controller.text,
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserInternship(updatedItemForDatabase);
    var savedItemIndex = _userInternships.indexWhere((element) => element.id == updatedItemForDatabase.id);
    if (savedItemIndex != -1) {
      _userInternships[savedItemIndex] = updatedItemForDatabase;
    }

    Fluttertoast.showToast(msg: 'Updated internship...', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.green.withOpacity(0.8), textColor: Colors.white, fontSize: 16.0);
  }

  // Delete the internship given index
  Future<void> removeItem(int index) async {
    var itemToDelete = item[index];
    item.removeAt(index);
    itemToDelete.dispose();

    if (resume.isNull) {
      var itemToDeleteDatabaseIndex = _userInternships.indexWhere((element) => element.id == itemToDelete.id);
      if (itemToDeleteDatabaseIndex != -1) {
        _userInternships.removeAt(itemToDeleteDatabaseIndex);
        await DatabaseService().deleteUserInternship(DeleteDocuments(itemToDelete.id));
      }
    }

    Fluttertoast.showToast(msg: 'Deleted...', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white, fontSize: 16.0);
  }

  // Add new item to the list and if possible add it to the database
  Future<void> addNewItem() async {
    var id = getLatestId();

    var itemToAdd = CustomInternshipItem(
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
        updateInternship(event);
      });

      // add to the database
      var itemForDatabase = UserInternship(
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

      var addedItem = await DatabaseService().addUpdateUserInternship(itemForDatabase);
      _userInternships.add(addedItem!);
      itemToAdd.id = addedItem.id;
      item.add(itemToAdd);
    } else {
      item.add(itemToAdd);
    }

    Fluttertoast.showToast(msg: 'Internship added', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
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

  dispose() {
    for (var element in item) {
      element.dispose();
    }
  }
}
