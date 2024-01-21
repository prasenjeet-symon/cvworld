// ignore: file_names
import 'package:cvworld/client/pages/dashboard/view-resume/view-resume.dart';
import 'package:flutter/material.dart';

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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("View Resume"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: ResumeViewer(resumeID: widget.resumeID),
        ),
      ),
    );
  }
}
