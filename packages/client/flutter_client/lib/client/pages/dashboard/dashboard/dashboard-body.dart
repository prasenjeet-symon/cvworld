// ignore: file_names
import 'dart:async';

import 'package:cvworld/client/shared/empty-data/empty-data.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class DashboardBodyContent extends StatefulWidget {
  final double resumeWidth;
  const DashboardBodyContent({super.key, required this.resumeWidth});

  @override
  State<DashboardBodyContent> createState() => _DashboardBodyContentState();
}

class _DashboardBodyContentState extends State<DashboardBodyContent> {
  late final DashboardContentLogic logic;
  Timer? timer;

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

    timer = Timer.periodic(const Duration(seconds: Constants.refreshSeconds), (timer) async {
      TimerHolder().addTimer(timer);
      await logic.fetchAllCreatedResume(canShowLoading: false);
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
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
      return EmptyData(title: 'No Created Resume', description: 'You have not created any resume. Please create one', image: 'no-resume.png');
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
