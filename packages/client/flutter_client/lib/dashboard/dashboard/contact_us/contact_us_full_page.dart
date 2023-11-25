import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/dashboard/contact_us/contact_us_page.dart';
import 'package:flutter/material.dart';

class AdminContactUsFullPage extends StatefulWidget {
  final String messageId;

  const AdminContactUsFullPage({super.key, required this.messageId});

  @override
  State<AdminContactUsFullPage> createState() => _AdminContactUsPageFullState();
}

class _AdminContactUsPageFullState extends State<AdminContactUsFullPage> {
  ContactUsLogic contactUsLogic = ContactUsLogic();

  @override
  void initState() {
    super.initState();
    contactUsLogic.getSingleMessage(int.parse(widget.messageId), setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: contactUsLogic.isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  width: 800,
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BackButtonApp(onPressed: () {
                        Navigator.pop(context);
                      }),
                      const SizedBox(height: 50),
                      // Heading "Customer Inquiry"
                      Text(
                        '${contactUsLogic.singleMessage!.name}\'s Inquiry #${contactUsLogic.singleMessage!.id}',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      // subheading holding email
                      Text(
                        'Email: ${contactUsLogic.singleMessage!.email}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 35),
                      // message card
                      CustomerIssueCard(issue: contactUsLogic.singleMessage!, canCutText: false),
                      const SizedBox(height: 50),
                      // Mark resolved button is not resolved
                      if (!contactUsLogic.singleMessage!.isResolved)
                        ElevatedButton(
                          onPressed: () {
                            contactUsLogic.markAsResolved(context, int.parse(widget.messageId), setState);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text('Mark as Resolved'),
                        )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
