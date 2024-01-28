import 'dart:async';

import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/dashboard/users/user_profile_page.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminAllUsersPage extends StatefulWidget {
  const AdminAllUsersPage({super.key});

  @override
  State<AdminAllUsersPage> createState() => _AdminAllUsersPageState();
}

class _AdminAllUsersPageState extends State<AdminAllUsersPage> {
  final AdminAllUsersLogic adminAllUsersLogic = AdminAllUsersLogic();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    adminAllUsersLogic.fetchAllUsers(setState, canShowLoading: true);

    timer = Timer.periodic(const Duration(seconds: Constants.refreshSeconds), (timer) async {
      await adminAllUsersLogic.fetchAllUsers(setState, canShowLoading: false);
    });

    TimerHolder().addTimer(timer);
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adminAllUsersLogic.fetchAllUsers(setState, canShowLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: adminAllUsersLogic.isLoading
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
                    BackButtonApp(onPressed: () => {Navigator.pop(context)}),
                    const SizedBox(height: 50),
                    const Text('Registered Users', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 35),
                    Expanded(
                      child: adminAllUsersLogic.users.isEmpty
                          ? const NoResultFound(icon: Icons.warning_amber_rounded, heading: 'No Users', description: 'No users registered yet! Please add some users')
                          : ListView.builder(
                              itemCount: adminAllUsersLogic.users.length,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => {
                                    context.pushNamed(RouteNames.adminUserProfile, pathParameters: {"userId": adminAllUsersLogic.users[index].reference})
                                  },
                                  leading: CircleAvatar(backgroundImage: NetworkImage(adminAllUsersLogic.users[index].profilePicture)),
                                  title: Text(adminAllUsersLogic.users[index].fullName),
                                  subtitle: Text(adminAllUsersLogic.users[index].subscription?.isActive ?? false ? 'Subscriber' : 'Not a Subscriber'),
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
  bool isLoading = false;

  Future<void> fetchAllUsers(void Function(void Function()) setState, {bool canShowLoading = true}) async {
    try {
      debugPrint('Will fetch');

      setState(() {
        isLoading = canShowLoading;
      });

      List<User>? response = await DashboardDataService().getUsers();
      debugPrint('Got response');

      if (response == null) {
        setState(() {
          isLoading = false;
          users = [];
        });

        return;
      }

      setState(() {
        isLoading = false;
        users = response;
      });

      debugPrint('Fetched ${users.length} users');
    } catch (e) {
      // Handle any errors that occurred during the fetch operation
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
    }
  }
}
