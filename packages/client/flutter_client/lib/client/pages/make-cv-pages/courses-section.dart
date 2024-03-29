// ignore: file_names

import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/make-cv-pages/expandable-card.dart';
import 'package:cvworld/client/pages/make-cv-pages/side-by-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/text-input.dart';
import 'package:cvworld/client/pages/make-cv-pages/types.dart';
import 'package:cvworld/client/utils.dart';
import 'package:rxdart/rxdart.dart';

class CourseSection extends StatefulWidget {
  final String title;
  final String description;
  final Resume? resume;

  const CourseSection({Key? key, required this.title, required this.description, this.resume}) : super(key: key);

  @override
  State<CourseSection> createState() => CourseSectionState();
}

class CourseSectionState extends State<CourseSection> {
  final CustomCourseSection _customCourseSection = CustomCourseSection();

  List<Courses> getData() {
    return _customCourseSection.item
        .map((e) => {
              Courses(
                e.course.controller.text,
                e.institution.controller.text,
                DateTime.parse(e.startDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : e.startDate.controller.text),
                DateTime.parse(e.endDate.controller.text.isEmpty ? DateTime.now().toIso8601String() : e.endDate.controller.text),
              )
            })
        .expand((element) => element)
        .toList();
  }

  addNewItem() {
    _customCourseSection.addNewItem().then((value) => {setState(() {})});
  }

  removeItem(int index) {
    _customCourseSection.removeItem(index).then((value) => {setState(() {})});
  }

  @override
  void dispose() {
    _customCourseSection.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _customCourseSection.resume = widget.resume;
    _customCourseSection.fetchCourses().then((value) => {setState(() {})});
    _customCourseSection.patchResume().then((value) => {setState(() {})});
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
            margin: _customCourseSection.item.isNotEmpty ? const EdgeInsets.fromLTRB(0, 15, 0, 15) : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _customCourseSection.item
                  .asMap()
                  .map(
                    (i, e) => MapEntry(
                        i,
                        CourseItem(
                          customCoursesItem: e,
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
                    _customCourseSection.item.isNotEmpty ? const Text('Add one more course') : const Text('Add course'),
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
///
class CourseItem extends StatefulWidget {
  final DeleteFunction onDelete;
  final CustomCoursesItem customCoursesItem;
  final int index;

  const CourseItem({
    super.key,
    required this.onDelete,
    required this.customCoursesItem,
    required this.index,
  });

  @override
  State<CourseItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  bool isExpanded = true;
  String heading = 'Language Item';

  @override
  void initState() {
    super.initState();
    widget.customCoursesItem.generateCustomInputFields();
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

  void deleteCourse(BuildContext context, int courseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and delete the course
                widget.onDelete(courseId);
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
      title: 'Course Item',
      onDelete: (int index) => deleteCourse(context, index),
      children: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SideBySideInputs(
              inputFields: [
                widget.customCoursesItem.courseField,
                widget.customCoursesItem.institutionField,
              ].toList(),
            ),
            SideBySideInputs(
              inputFields: [
                widget.customCoursesItem.startDateField,
                widget.customCoursesItem.endDateField,
              ].toList(),
            )
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
class CustomCoursesItem {
  int id;
  final CustomInputType course;
  final CustomInputType institution;
  final CustomInputType startDate;
  final CustomInputType endDate;

  late CustomInputField courseField;
  late CustomInputField institutionField;
  late CustomInputField startDateField;
  late CustomInputField endDateField;

  BehaviorSubject<int> controller = BehaviorSubject();

  CustomCoursesItem({
    required this.course,
    required this.institution,
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  // listen for any control changes
  Stream<int> listenForChanges() {
    course.controller.addListener(() {
      controller.add(id);
    });

    institution.controller.addListener(() {
      controller.add(id);
    });

    startDate.controller.addListener(() {
      controller.add(id);
    });

    endDate.controller.addListener(() {
      controller.add(id);
    });

    return controller.debounceTime(const Duration(milliseconds: Constants.debounceTime));
  }

  // dispose
  dispose() {
    // remove listener
    course.controller.removeListener(() {});
    institution.controller.removeListener(() {});
    startDate.controller.removeListener(() {});
    endDate.controller.removeListener(() {});

    course.controller.dispose();
    institution.controller.dispose();
    startDate.controller.dispose();
    endDate.controller.dispose();

    controller.close();
  }

  generateCustomInputFields() {
    courseField = CustomInputField(
      label: course.label,
      isRequired: course.isRequired,
      controller: course.controller,
      type: course.type,
    );

    institutionField = CustomInputField(
      label: institution.label,
      isRequired: institution.isRequired,
      controller: institution.controller,
      type: institution.type,
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
  }
}

///
///
///
///
///
///
class CustomCourseSection {
  List<CustomCoursesItem> item = [];
  final List<TextEditingController> _controllers = [];
  List<UserCourse> courses = [];
  Resume? resume;

  TextEditingController _addController() {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller);
    return controller;
  }

  // patch the resume if applicable
  Future<void> patchResume() async {
    if (resume == null) return;
    var coursesToPatch = resume!.courses;

    for (var element in coursesToPatch) {
      var courseController = _addController();
      courseController.text = element.course;

      var institutionController = _addController();
      institutionController.text = element.institution;

      var startDateController = _addController();
      startDateController.text = formatDateTime(element.startDate);

      var endDateController = _addController();
      endDateController.text = formatDateTime(element.endDate);

      var courseItem = CustomCoursesItem(
        id: getId(),
        course: CustomInputType('Course', 'course', true, courseController, TextInputType.text),
        institution: CustomInputType('Institution', 'institution', true, institutionController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
      );

      item.add(courseItem);
    }
  }

  // Fetch already created courses by the user
  Future<void> fetchCourses() async {
    if (!(resume == null)) return;

    var createdCourses = await DatabaseService().fetchUserCourses();
    if (createdCourses == null) return;
    courses = createdCourses;

    for (var element in courses) {
      var courseController = _addController();
      courseController.text = element.course;

      var institutionController = _addController();
      institutionController.text = element.institution;

      var startDateController = _addController();
      startDateController.text = formatDateTime(element.startDate);

      var endDateController = _addController();
      endDateController.text = formatDateTime(element.endDate);

      var courseItem = CustomCoursesItem(
        id: element.id,
        course: CustomInputType('Course', 'course', true, courseController, TextInputType.text),
        institution: CustomInputType('Institution', 'institution', true, institutionController, TextInputType.text),
        startDate: CustomInputType('Start Date', 'startDate', true, startDateController, TextInputType.datetime),
        endDate: CustomInputType('End Date', 'endDate', true, endDateController, TextInputType.datetime),
      );

      item.add(courseItem);

      courseItem.listenForChanges().listen((event) {
        // save the updated value here
        updateItem(event);
      });
    }
  }

  // Get the latest id of the course
  getId() {
    var maxId = 0;
    for (var element in item) {
      if (element.id > maxId) {
        maxId = element.id;
      }
    }

    return maxId + 1;
  }

  dispose() {
    for (var element in item) {
      element.dispose();
    }
  }

  Future<void> addNewItem() async {
    var id = getId();

    var courseItem = CustomCoursesItem(
      id: id,
      course: CustomInputType('Course', 'course', true, _addController(), TextInputType.text),
      institution: CustomInputType('Institution', 'institution', true, _addController(), TextInputType.text),
      endDate: CustomInputType('End Date', 'endDate', true, _addController(), TextInputType.datetime),
      startDate: CustomInputType('Start Date', 'startDate', true, _addController(), TextInputType.datetime),
    );

    if (resume == null) {
      // listen for the changes and update the item
      courseItem.listenForChanges().listen((event) {
        // save the updated value here
        updateItem(event);
      });

      // after adding get the added course

      UserCourse userCourse = UserCourse(
        courseItem.id,
        courseItem.course.controller.text,
        courseItem.institution.controller.text,
        courseItem.startDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(courseItem.startDate.controller.text),
        courseItem.endDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(courseItem.endDate.controller.text),
        DateTime.now(),
        DateTime.now(),
      );

      var addedItem = await DatabaseService().addUpdateUserCourse(userCourse);
      courses.add(addedItem!);
      courseItem.id = addedItem.id;
      item.add(courseItem);
    } else {
      item.add(courseItem);
    }
  }

  Future<void> removeItem(int index) async {
    // find the course in the list
    var courseToDelete = item[index];
    courseToDelete.dispose();
    item.removeAt(index);

    if (resume == null) {
      var courseToDeleteDatabaseIndex = courses.indexWhere((element) => element.id == courseToDelete.id);
      if (courseToDeleteDatabaseIndex != -1) {
        courses.removeAt(courseToDeleteDatabaseIndex);
        // remove the course from the database
        await DatabaseService().deleteUserCourse(DeleteDocuments(courseToDelete.id));
      }
    }
  }

  // update the item
  updateItem(int id) async {
    var courseIndex = item.indexWhere((element) => element.id == id);
    if (courseIndex == -1) return;
    var course = item[courseIndex];

    var updatedCourse = UserCourse(
      course.id,
      course.course.controller.text,
      course.institution.controller.text,
      course.startDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(course.startDate.controller.text),
      course.endDate.controller.text.isEmpty ? DateTime.now() : DateTime.parse(course.endDate.controller.text),
      DateTime.now(),
      DateTime.now(),
    );

    await DatabaseService().addUpdateUserCourse(updatedCourse);
    var savedItemIndexChanged = courses.indexWhere((element) => element.id == updatedCourse.id);
    if (savedItemIndexChanged != -1) {
      courses[savedItemIndexChanged] = updatedCourse;
    }
  }
}
