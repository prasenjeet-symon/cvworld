import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/client/datasource.dart' as client;
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';
import 'package:intl/intl.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, @PathParam() required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfileLogic userProfileLogic = UserProfileLogic();

  @override
  void initState() {
    super.initState();
    userProfileLogic.init(setState, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: userProfileLogic.isLoading
            ? const CircularProgressIndicator()
            : Container(
                margin: const EdgeInsets.only(top: 5),
                width: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackButtonApp(onPressed: () {
                      context.popRoute(UserProfilePage(userId: widget.userId));
                    }),
                    const SizedBox(height: 40),
                    Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                      // circular image
                      CircleAvatar(
                        backgroundImage: NetworkImage(userProfileLogic.user!.profilePicture),
                        radius: 80,
                      ),
                      const SizedBox(height: 10),
                      Text(userProfileLogic.user!.fullName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      // is subscriber
                      InputChip(
                        label: Text(
                          userProfileLogic.user!.subscription != null ? 'Subscriber' : 'Not a Subscriber',
                          style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {},
                        backgroundColor: userProfileLogic.user!.subscription != null ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 20),
                      // border line
                      const Divider(thickness: 2, color: Colors.black),
                      const SizedBox(height: 20),
                      // List all the bought template
                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        // Heading "Bought Templates"
                        const Text(
                          'Bought Templates',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        // list all the bought template card with image and title and price in rupee
                        userProfileLogic.boughtTemplate!.isEmpty
                            ? const NoResultFound(
                                heading: 'No Bought Templates',
                                icon: Icons.warning_amber_rounded,
                                description: 'Once this user will buy a template you will see it here',
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: userProfileLogic.boughtTemplate?.length,
                                itemBuilder: (context, index) => BoughtTemplateCard(boughtTemplate: userProfileLogic.boughtTemplate![index], isMobile: MediaQuery.of(context).size.width < Constants.breakPoint, onPressed: () {}),
                              ),

                        // List all the resume
                        const SizedBox(height: 45),
                        // Heading "Resumes"
                        const Text(
                          'Resumes',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        // list all the resume card
                        userProfileLogic.resumes!.isEmpty
                            ? const NoResultFound(heading: 'No Resumes', icon: Icons.warning_amber_rounded, description: 'Once this user will create a resume you will see it here')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: userProfileLogic.resumes?.length,
                                itemBuilder: (context, index) => ResumeCard(
                                  resume: userProfileLogic.resumes![index],
                                ),
                              ),
                        // List all the bought templates transactions
                        const SizedBox(height: 45),
                        // Heading "Transactions"
                        const Text(
                          'Transactions',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        // list all the transactions
                        userProfileLogic.transactions!.isEmpty
                            ? const NoResultFound(heading: 'No Transactions', icon: Icons.warning_amber_rounded, description: 'Once this user will buy a template you will see all related transactions here')
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: userProfileLogic.transactions?.length,
                                itemBuilder: (context, index) => TransactionCard(
                                  transaction: userProfileLogic.transactions![index],
                                ),
                              ),
                        const SizedBox(height: 50),
                      ])
                    ])
                  ],
                ),
              ),
      )),
    );
  }
}

///
///
///
///
///
/// Bought Templates Card
class BoughtTemplateCard extends StatelessWidget {
  final BoughtTemplate boughtTemplate;
  final bool isMobile;
  final VoidCallback onPressed;

  const BoughtTemplateCard({super.key, required this.boughtTemplate, required this.isMobile, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.card_membership),
        title: Text(boughtTemplate.name),
        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(boughtTemplate.createdAt)),
        trailing: Text(
          NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(boughtTemplate.price / 100),
          style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        onTap: onPressed,
      ),
    );
  }
}

// Generated resume card
class ResumeCard extends StatelessWidget {
  final client.GeneratedResume? resume;

  const ResumeCard({super.key, required this.resume});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          resume!.resumeLink.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(resume!.templateName),
        subtitle: Text(
          DateFormat.yMMMMd().format(resume!.createdAt), // Format the date as human-readable
          style: const TextStyle(
            fontSize: 12, // You can adjust the font size as needed
            color: Colors.grey,
          ),
        ),
        // You can add more details here or customize the ListTile further
      ),
    );
  }
}

// Template transaction card
class TransactionCard extends StatelessWidget {
  final TemplateTransaction transaction;

  const TransactionCard({super.key, required this.transaction});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: transaction.orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order ID copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: ListTile(
          title: Text('Method: ${transaction.method}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text('Created At: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.createdAt)}'),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _copyToClipboard(context),
                child: Text(
                  'Order ID: ${transaction.orderId}',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          trailing: Text(
            NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(transaction.amountPaid / 100),
            style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
          )),
    );
  }
}

// No result found
class NoResultFound extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String description;

  const NoResultFound({
    super.key,
    required this.icon,
    required this.heading,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, size: 72, color: Colors.blue), // Big Icon
            const SizedBox(height: 16),
            Text(
              heading,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
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

class UserProfileLogic {
  bool isLoading = true;

  User? user;
  List<BoughtTemplate>? boughtTemplate;
  List<client.GeneratedResume?>? resumes;
  List<TemplateTransaction>? transactions;

  // init
  Future<void> init(void Function(void Function()) setState, String reference) async {
    setState(() {
      isLoading = true;
    });
    await fetchUser(setState, reference);
    await fetchBoughtTemplate(setState, reference);
    await fetchAllResumes(setState, reference);
    await fetchTransactions(setState, reference);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchUser(void Function(void Function()) setState, String reference) async {
    user = await DashboardDataService().getSingleUser(reference);
  }

  Future<void> fetchBoughtTemplate(void Function(void Function()) setState, String reference) async {
    boughtTemplate = await DashboardDataService().getBoughtTemplates(reference);
  }

  Future<void> fetchAllResumes(void Function(void Function()) setState, String reference) async {
    resumes = await DashboardDataService().getGeneratedResumes(reference);
  }

  Future<void> fetchTransactions(void Function(void Function()) setState, String reference) async {
    transactions = await DashboardDataService().getTransactionOfBoughtTemplates(reference);
  }
}
