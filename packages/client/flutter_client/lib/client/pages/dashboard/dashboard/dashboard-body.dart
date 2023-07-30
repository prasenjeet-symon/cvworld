import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';

import 'dashboard.dart';

class DashboardBodyContent extends StatefulWidget {
  final double resumeWidth;
  const DashboardBodyContent({super.key, required this.resumeWidth});

  @override
  State<DashboardBodyContent> createState() => _DashboardBodyContentState();
}

class _DashboardBodyContentState extends State<DashboardBodyContent> {
  late final DashboardContentLogic logic;

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    logic = DashboardContentLogic(setStateCallback: _updateState);
    logic.fetchAllCreatedResume();
  }

  @override
  Widget build(BuildContext context) {
    if (logic.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (logic.resumes.isEmpty) {
      return const ShiningImageSection();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 45, 0, 45),
      child: Wrap(
        alignment: WrapAlignment.start,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 20, // Spacing between the children horizontally
        runSpacing: 20, // Spacing between the lines vertically
        children: [
          ...logic.resumes.map(
            (e) => CreatedResumeItem(
              deleteFunction: logic.deleteResume,
              downloadFunction: logic.downloadResume,
              editFunction: (int id) => logic.editResume(context, id),
              resume: e,
              width: widget.resumeWidth,
            ),
          )
        ],
      ),
    );
  }
}
