import 'package:cvworld/client/pages/dashboard/view-resume/view-resume.dart';
import 'package:flutter/material.dart';

class ViewResumeDesktop extends StatefulWidget {
  final int resumeID;
  const ViewResumeDesktop({super.key, required this.resumeID});

  @override
  State<ViewResumeDesktop> createState() => _ViewResumeDesktopState();
}

class _ViewResumeDesktopState extends State<ViewResumeDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [ResumeViewer(resumeID: widget.resumeID)],
        ),
      ),
    );
  }
}
