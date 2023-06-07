import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/expandable-card.dart';
import 'package:flutter_client/client/pages/make-cv-pages/side-by-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/text-input.dart';
import 'package:flutter_client/client/pages/make-cv-pages/types.dart';

class CourseSection extends StatefulWidget {
  final String title;
  final String description;

  const CourseSection(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<CourseSection> createState() => _CourseSectionState();
}

class _CourseSectionState extends State<CourseSection> {
  getJSON() {}

  final CustomCourseSection _CustomCourseSection = CustomCourseSection();

  addNewItem() {
    _CustomCourseSection.addNewItem();
    setState(() {});
  }

  removeItem(int index) {
    _CustomCourseSection.removeItem(index);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _CustomCourseSection.dispose();
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
            margin: _CustomCourseSection.item.isNotEmpty
                ? const EdgeInsets.fromLTRB(0, 15, 0, 15)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _CustomCourseSection.item
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
                    _CustomCourseSection.item.isNotEmpty
                        ? const Text('Add one more course')
                        : const Text('Add course'),
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

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      index: widget.index,
      title: 'Course Item',
      onDelete: widget.onDelete,
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

/** 
 * 
 * 
 * 
 */
class CustomCoursesItem {
  final CustomInputType course;
  final CustomInputType institution;
  final CustomInputType startDate;
  final CustomInputType endDate;

  late CustomInputField courseField;
  late CustomInputField institutionField;
  late CustomInputField startDateField;
  late CustomInputField endDateField;

  CustomCoursesItem({
    required this.course,
    required this.institution,
    required this.startDate,
    required this.endDate,
  });

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

class CustomCourseSection {
  List<CustomCoursesItem> item = [];
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
    item.add(CustomCoursesItem(
      course: CustomInputType(
        'Course',
        'course',
        true,
        _addController(),
        TextInputType.text,
      ),
      institution: CustomInputType(
        'Institution',
        'institution',
        true,
        _addController(),
        TextInputType.text,
      ),
      endDate: CustomInputType(
        'End Date',
        'endDate',
        true,
        _addController(),
        TextInputType.datetime,
      ),
      startDate: CustomInputType(
        'Start Date',
        'startDate',
        true,
        _addController(),
        TextInputType.datetime,
      ),
    ));
  }

  void removeItem(int index) {
    item.removeAt(index);
  }
}
