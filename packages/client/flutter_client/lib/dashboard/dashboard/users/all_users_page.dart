import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/dashboard/users/user_profile_page.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';
import 'package:cvworld/routes/router.gr.dart' as router;

@RoutePage()
class AdminAllUsersPage extends StatefulWidget {
  const AdminAllUsersPage({super.key});

  @override
  State<AdminAllUsersPage> createState() => _AdminAllUsersPageState();
}

class _AdminAllUsersPageState extends State<AdminAllUsersPage> {
  final AdminAllUsersLogic adminAllUsersLogic = AdminAllUsersLogic();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    adminAllUsersLogic.fetchAllUsers(setState).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
          : Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                width: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackButtonApp(onPressed: () => {context.popRoute(const router.AdminAllUsersPage())}),
                    const SizedBox(height: 50),
                    const Text('Registered Users', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 35),
                    Expanded(
                      child: adminAllUsersLogic.users.isEmpty
                          ? const NoResultFound(icon: Icons.warning_amber_rounded, heading: 'No Users', description: 'No users registered yet! Please add some users')
                          : ListView.builder(
                              itemCount: adminAllUsersLogic.users.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => {context.pushRoute(router.UserProfilePage(userId: adminAllUsersLogic.users[index].reference))},
                                  leading: CircleAvatar(backgroundImage: NetworkImage(adminAllUsersLogic.users[index].profilePicture)),
                                  title: Text(adminAllUsersLogic.users[index].fullName),
                                  subtitle: Text(adminAllUsersLogic.users[index].subscription != null ? 'Subscriber' : 'Not a Subscriber'),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class AdminAllUsersLogic {
  List<User> users = [];

  Future<void> fetchAllUsers(void Function(void Function()) setState) async {
    // fetch
    var response = await DashboardDataService().getUsers();
    if (response != null) {
      users = response;
      setState(() {});
    }
  }
}
