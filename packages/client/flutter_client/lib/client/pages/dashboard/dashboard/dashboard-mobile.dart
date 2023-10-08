import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/dashboard/dashboard/dashboard-body.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  late AppDrawerLogic logic;

  @override
  initState() {
    super.initState();
    logic = AppDrawerLogic(() {
      if (mounted) {
        setState(() {});
      }
    });

    logic.init();
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
          context.pushRoute(const MarketPlacePage());
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

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the logout action
                DatabaseService().logout().then((value) {
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Navigate to the SignInRoute after logout
                  context.pushRoute(const SignInRoute());
                });
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSubscriber = false;
    if (widget.logic.user != null && widget.logic.user!.subscription != null && widget.logic.user!.subscription!.isActive) {
      isSubscriber = true;
    } else {
      isSubscriber = false;
    }

    return Drawer(
      child: widget.logic.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: ProfileWidget(fullName: widget.logic.user!.fullName, imageUrl: widget.logic.user!.profilePicture, isPremium: isSubscriber),
                ),
                DrawerMenuItem(
                  icon: Icons.home,
                  title: 'Dashboard',
                  onTap: () {
                    context.pushRoute(const Dashboard());
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.settings,
                  title: 'Account Settings',
                  onTap: () {
                    context.pushRoute(const AccountSettingPage());
                  },
                ),
                const Divider(), // Add a divider between menu items and app info
                DrawerMenuItem(
                  icon: Icons.mail,
                  title: 'Contact Us',
                  onTap: () {
                    // Handle menu item tap here
                    context.pushRoute(const ContactUsPage());
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
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 25,
        ),
        const SizedBox(height: 5),
        Text(
          fullName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        isPremium
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Premium',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : GestureDetector(
                onTap: () {
                  context.pushRoute(const AccountSettingPage());
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
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

  Future<void> init() async {
    getAppVersion();
    await getUser();
  }

  Future<void> getUser() async {
    try {
      isLoading = true;
      updateState();
      user = await DatabaseService().fetchUser();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      Fluttertoast.showToast(msg: 'Failed to fetch user', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
    } finally {
      isLoading = false;
      updateState();
    }
  }
}
