import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/dashboard/view-resume/view-resume.dart';

class ViewResumeMobile extends StatefulWidget {
  final int resumeID;
  const ViewResumeMobile({super.key, required this.resumeID});

  @override
  State<ViewResumeMobile> createState() => _ViewResumeMobileState();
}

class _ViewResumeMobileState extends State<ViewResumeMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Add your action here
            context.popRoute(ViewResume(resumeID: widget.resumeID));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("View Resume"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: ResumeViewer(resumeID: widget.resumeID),
          )),
    );
  }
}
