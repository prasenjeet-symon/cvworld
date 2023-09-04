import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, @PathParam() required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfileLogic userProfileLogic;

  @override
  void initState() {
    super.initState();
    userProfileLogic = UserProfileLogic(reference: widget.userId);
    userProfileLogic.fetchUser(setState);
    userProfileLogic.fetchBoughtTemplate(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: userProfileLogic.isLoading
            ? const CircularProgressIndicator()
            : Container(
                margin: const EdgeInsets.only(top: 70),
                width: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackButtonApp(onPressed: () {
                      context.popRoute(UserProfilePage(userId: widget.userId));
                    }),
                    const SizedBox(height: 60),
                    Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                      // circular image
                      CircleAvatar(
                        backgroundImage: NetworkImage(userProfileLogic.user!.profilePicture),
                        radius: 50,
                      ),
                      const SizedBox(height: 35),
                      Text(userProfileLogic.user!.fullName, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 35),
                      // is subscriber
                      Text(userProfileLogic.user!.subscription != null ? 'Subscriber' : 'Not a Subscriber', style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                      // border line
                      const Divider(thickness: 2, color: Colors.black, indent: 50, endIndent: 50),

                      // List all the bought template
                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        // Heading "Bought Templates"
                        const Text(
                          'Bought Templates',
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 35),
                        // list all the bought template card with image and title and price in rupee
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: userProfileLogic.boughtTemplate?.length,
                        //   itemBuilder: (context, index) => BoughtTemplateCard(boughtTemplate: userProfileLogic.boughtTemplate![index], isMobile: MediaQuery.of(context).size.width < Constants.breakPoint, onPressed: () {}),
                        // )
                      ])
                    ])
                  ],
                ),
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
        subtitle: Text(boughtTemplate.createdAt.toString()),
        trailing: Text(boughtTemplate.price.toString()),
        onTap: onPressed,
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
  final String reference;

  late User user;
  List<BoughtTemplate>? boughtTemplate;
  bool isLoading = true;

  UserProfileLogic({required this.reference});

  Future<void> fetchUser(void Function(void Function()) setState) async {
    isLoading = true;
    setState(() {});
    var user = await DashboardDataService().getSingleUser(reference);
    user = user;
    isLoading = false;
    setState(() {});
  }

  Future<void> fetchBoughtTemplate(void Function(void Function()) setState) async {
    isLoading = true;
    setState(() {});
    boughtTemplate = await DashboardDataService().getBoughtTemplates(reference);
    isLoading = false;
    setState(() {});
  }
}
