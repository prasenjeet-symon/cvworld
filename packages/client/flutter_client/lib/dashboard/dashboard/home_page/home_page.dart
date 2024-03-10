import 'dart:async';

import 'package:cvworld/dashboard/datasource/http/http.manager.admin.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AdminHomePageLogic adminHomePageLogic = AdminHomePageLogic();
  StreamSubscription? _subscription;

  Future<void> confirmLogout(BuildContext ctx) async {
    // Show a confirmation dialog
    final bool confirm = await showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and return true (confirm)
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    // If the user confirms, proceed with logout
    if (confirm) {
      ApplicationToken.getInstance().deleteToken();
    }
  }

  @override
  void initState() {
    super.initState();
    adminHomePageLogic.fetchAdminDetails(setState);

    _subscription = ApplicationToken.getInstance().observable.listen((event) {
      if (event == null) {
        context.goNamed(RouteNames.adminSignin);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: adminHomePageLogic.isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
              : Container(
                  margin: const EdgeInsets.only(top: 70),
                  width: 800,
                  child: Column(
                    children: [
                      Text('Welcome, ${adminHomePageLogic.admin!.fullName}!', style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HoverCard(title: 'All Users', icon: Icons.people, onTap: () => context.pushNamed(RouteNames.adminAllUsers)),
                          HoverCard(title: 'All Templates', icon: Icons.format_list_bulleted, onTap: () => {context.pushNamed(RouteNames.adminAllTemplates)}),
                          HoverCard(title: 'Subscription Settings', icon: Icons.settings, onTap: () => context.pushNamed(RouteNames.adminSubscriptionSetting)),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HoverCard(title: 'Update Password', icon: Icons.password, onTap: () => context.pushNamed(RouteNames.adminChangePassword)),
                          HoverCard(title: 'Contact Us Messages', icon: Icons.message, onTap: () => context.pushNamed(RouteNames.adminContactUs)),
                          HoverCard(title: 'Feedback', icon: Icons.feedback, onTap: () => context.pushNamed(RouteNames.adminFeedbackPage)),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HoverCard(title: 'Sign Out', icon: Icons.logout, onTap: () => confirmLogout(context)),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
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

class HoverCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const HoverCard({super.key, required this.icon, required this.title, required this.onTap});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Invoke the onTap callback when clicked
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: Card(
          elevation: isHovered ? 6 : 3, // Increase elevation on hover
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 35, 20, 35),
            child: SizedBox(
              width: 170,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: 48, color: isHovered ? Colors.red : Colors.blue), // Change icon color on hover
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 16, color: isHovered ? Colors.red : Colors.black), // Change text color on hover
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
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
/// Admin Home page Logic
class AdminHomePageLogic {
  bool isLoading = true;
  Admin? admin;

  // Fetch the admin details
  Future<void> fetchAdminDetails(void Function(void Function()) setState) async {
    setState(() => isLoading = true);
    admin = await DashboardDataService().getAdminDetails();
    setState(() => isLoading = false);
  }
}
