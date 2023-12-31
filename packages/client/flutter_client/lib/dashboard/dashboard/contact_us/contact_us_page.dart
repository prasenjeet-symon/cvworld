import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/dashboard/users/user_profile_page.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:intl/intl.dart';

@RoutePage()
class AdminContactUsPage extends StatefulWidget {
  const AdminContactUsPage({super.key});

  @override
  State<AdminContactUsPage> createState() => _AdminContactUsPageState();
}

class _AdminContactUsPageState extends State<AdminContactUsPage> {
  ContactUsLogic contactUsLogic = ContactUsLogic();

  @override
  void initState() {
    super.initState();
    contactUsLogic.fetchMessages(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contactUsLogic.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back button
                    BackButtonApp(onPressed: () {
                      context.popRoute();
                    }),
                    const SizedBox(height: 50),
                    // Heading "Customer Inquiry"
                    const Text(
                      'Customer Inquiry',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 35),
                    // List all the users's inquiry
                    contactUsLogic.messages!.isEmpty
                        ? const NoResultFound(icon: Icons.question_answer, heading: 'No Messages', description: 'No messages yet! Once your user will send a message you will see it here')
                        : ListView.builder(
                            itemCount: contactUsLogic.messages!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => CustomerIssueCard(issue: contactUsLogic.messages![index], canCutText: true),
                          )
                  ],
                ),
              ),
            ),
    );
  }
}

class CustomerIssueCard extends StatelessWidget {
  final ContactUsMessage issue;
  final bool canCutText;

  const CustomerIssueCard({super.key, required this.issue, required this.canCutText});

  String formatCreatedAt() {
    final DateFormat formatter = DateFormat.yMd().add_jm();
    return formatter.format(issue.createdAt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: canCutText
          ? ListTile(
              onTap: () => context.pushRoute(
                AdminContactUsFullPage(messageId: issue.id.toString()),
              ),
              title: Text(
                issue.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Created At: ${formatCreatedAt()}'),
                  ResolvedBadge(isResolved: issue.isResolved),
                ],
              ),
              contentPadding: const EdgeInsets.all(16),
            )
          : SizedBox(
              width: double.infinity,
              child: Padding(padding: const EdgeInsets.all(16), child: Text(issue.message)),
            ),
    );
  }
}

class ResolvedBadge extends StatelessWidget {
  final bool isResolved;

  const ResolvedBadge({super.key, required this.isResolved});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isResolved ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isResolved ? 'Resolved' : 'Unresolved',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
/// Contact Us Logic
class ContactUsLogic {
  List<ContactUsMessage>? messages;
  bool isLoading = true;
  ContactUsMessage? singleMessage;

  // Fetch all messages
  Future<void> fetchMessages(void Function(void Function()) setState) async {
    setState(() => isLoading = true);
    messages = await DashboardDataService().getContactUsMessages();
    setState(() => isLoading = false);
  }

  // Fetch single contact us message
  Future<ContactUsMessage?> getSingleMessage(int id, void Function(void Function()) setState) async {
    setState(() => isLoading = true);
    singleMessage = await DashboardDataService().getSingleContactUsMessage(id);
    setState(() => isLoading = false);
  }

  // mark as resolved
  Future<void> markAsResolved(int id, void Function(void Function()) setState) async {
    await DashboardDataService().contactUsMessagesResolved(id);
    await fetchMessages(setState);
  }
}
