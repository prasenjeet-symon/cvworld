import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';

import '../../../routes/router.gr.dart';

@RoutePage()
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AdminHomePageLogic adminHomePageLogic = AdminHomePageLogic();

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
                // Close the dialog and return false (cancel)
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
    if (confirm == true) {
      await logoutAdmin();
      // ignore: use_build_context_synchronously
      ctx.pushRoute(const SignInDashboardPage());
    }
  }

  @override
  void initState() {
    super.initState();
    adminHomePageLogic.fetchAdminDetails(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: adminHomePageLogic.isLoading
            ? const Center(
                child: Padding(
                padding: EdgeInsets.all(50),
                child: CircularProgressIndicator(),
              ))
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
                        HoverCard(title: 'All Users', icon: Icons.people, onTap: () => context.pushRoute(const AdminAllUsersPage())),
                        HoverCard(title: 'All Templates', icon: Icons.format_list_bulleted, onTap: () => {context.pushRoute(const AllTemplatesPage())}),
                        HoverCard(title: 'Subscription Settings', icon: Icons.settings, onTap: () => context.pushRoute(const AdminSubscriptionSettingPage())),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HoverCard(title: 'Update Password', icon: Icons.password, onTap: () => context.pushRoute(const AdminChangePasswordPage())),
                        HoverCard(title: 'Contact Us Messages', icon: Icons.message, onTap: () => context.pushRoute(const AdminContactUsPage())),
                        HoverCard(title: 'Sign Out', icon: Icons.logout, onTap: () => confirmLogout(context)),
                      ],
                    )
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

class HoverCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  HoverCard({required this.icon, required this.title, required this.onTap});

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
