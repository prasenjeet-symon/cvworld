// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:cvworld/client/datasource/schema.dart' as schema;
import 'package:cvworld/client/pages/home-page/components/feedback/feedback.controller.dart';
import 'package:cvworld/client/pages/home-page/components/feedback/feedback.mobile.dart';
import 'package:cvworld/client/pages/home-page/components/feedback/feedback.web.dart';
import 'package:cvworld/client/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FeedbackComponent extends StatelessWidget {
  const FeedbackComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return const FeedbackMobileComponent();
      } else {
        return const FeedbackWebComponent();
      }
    });
  }
}

///
///
///
///
class FeedbackFormDialog extends StatefulWidget {
  const FeedbackFormDialog({super.key});

  @override
  State<FeedbackFormDialog> createState() => _FeedbackFormDialogState();
}

class _FeedbackFormDialogState extends State<FeedbackFormDialog> {
  final _formKey = GlobalKey<FormState>();

  List<String> feedbackTypes = ['Bug Report', 'Feature Request', 'Suggestion', 'Financial', 'Other'];
  String selectedFeedbackType = 'Bug Report';
  Uint8List? attachment;
  String? attachmentName;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  // Pick attachment
  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
      allowMultiple: false,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        attachment = result.files.first.bytes;
        attachmentName = result.files.first.name;
      });
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    titleController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Dialog(
      elevation: 1,
      child: SizedBox(
        width: isMobile ? 200 : 800,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text('Submit Feedback', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: fullNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!isValidEmail(value)) {
                      return 'Please enter a valid email address';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField(
                  value: selectedFeedbackType,
                  onChanged: (value) {
                    setState(() {
                      selectedFeedbackType = value ?? feedbackTypes.first;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Select', border: OutlineInputBorder()),
                  items: feedbackTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a feedback type';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: feedbackController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 3,
                  decoration: const InputDecoration(labelText: 'Feedback', alignLabelWithHint: true, border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }

                    return null;
                  },
                ),

                // File upload
                const SizedBox(height: 25),
                Row(
                  children: [
                    Text('Attach File: ${attachmentName ?? ''}'),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {
                          pickAttachment();
                        },
                        icon: const Icon(Icons.attach_file)),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: _submitForm,
                      child: const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), child: Text('Submit')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();

      String fullName = fullNameController.text;
      String email = emailController.text;
      String title = titleController.text;
      String feedback = feedbackController.text;
      String feedbackType = selectedFeedbackType;

      schema.Feedback finalFeedback = schema.Feedback(
        id: 1,
        name: fullName,
        email: email,
        title: title,
        description: feedback,
        department: feedbackType,
        isRegistered: false,
        identifier: const Uuid().v4(),
        attachment: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      finalFeedback.feedbackFile = attachment;
      finalFeedback.feedbackFileName = attachmentName;

      FeedbackController().add(finalFeedback);
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => const FeedbackSubmittedWidget());
    }
  }
}

///
///
///
///
bool isValidEmail(String email) {
  // Regular expression for validating an email address
  final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

///
///
///
///

class FeedbackSubmittedWidget extends StatelessWidget {
  const FeedbackSubmittedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return Dialog(
      child: SizedBox(
        width: isMobile ? 200 : 500,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text('Feedback Submitted Successfully', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
