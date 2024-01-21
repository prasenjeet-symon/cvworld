import 'dart:async';

import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard-body.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  late AppDrawerLogic logic;

  setStateCallback() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    logic = AppDrawerLogic(setStateCallback);
    logic.init();

    MySubjectSingleton.instance.dashboardHeaderSubject.listen((value) {
      if (mounted) {
        logic.init(canShowLoading: false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: DashboardDrawer(logic: logic),
      body: const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                DashboardBodyContent(resumeWidth: 200),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          // Nav to the marketplace page
          context.pushNamed(RouteNames.chooseTemplate);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DashboardDrawer extends StatefulWidget {
  final AppDrawerLogic logic;

  const DashboardDrawer({super.key, required this.logic});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  @override
  void initState() {
    super.initState();
  }

  void showLogoutConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (result != null && result == true) {
      // Perform the logout action
      DatabaseService().logout().then((value) {
        context.goNamed(RouteNames.signin);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is a subscriber
    bool isSubscriber = widget.logic.user?.subscription?.isActive ?? false;

    return Drawer(
      child: widget.logic.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: ProfileWidget(fullName: widget.logic.user?.fullName ?? '', imageUrl: widget.logic.user?.profilePicture ?? Constants.dummyProfilePic, isPremium: isSubscriber),
                ),
                DrawerMenuItem(
                  icon: Icons.settings,
                  title: 'Account Settings',
                  onTap: () {
                    context.pushNamed(RouteNames.dashboardAccountSetting);
                  },
                ),
                const Divider(), // Add a divider between menu items and app info
                DrawerMenuItem(
                  icon: Icons.mail,
                  title: 'Contact Us',
                  onTap: () {
                    // Handle menu item tap here
                    context.pushNamed(RouteNames.contactUs);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    showLogoutConfirmationDialog(context);
                  },
                ),
                const SizedBox(height: 20),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('App Version: ${widget.logic.appVersion}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                )
              ],
            ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItem({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String fullName;
  final bool isPremium;

  const ProfileWidget({
    super.key,
    required this.imageUrl,
    required this.fullName,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 25),
        const SizedBox(height: 5),
        Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        isPremium
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Premium',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
            : GestureDetector(
                onTap: () {
                  context.pushNamed(RouteNames.dashboardAccountSetting);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Upgrade',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ],
    );
  }
}

class AppDrawerLogic {
  String appVersion = '1.0.0';
  User? user;
  bool isLoading = false;
  final Function updateState;

  AppDrawerLogic(this.updateState);

  // get application version
  Future<void> getAppVersion() async {
    appVersion = '1.0.0';
  }

  Future<void> init({bool canShowLoading = true}) async {
    getAppVersion();
    await getUser(canShowLoading: canShowLoading);
  }

  Future<void> getUser({bool canShowLoading = true}) async {
    try {
      isLoading = canShowLoading;
      updateState();
      user = await DatabaseService().fetchUser();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading = false;
      updateState();
    }
  }
}
