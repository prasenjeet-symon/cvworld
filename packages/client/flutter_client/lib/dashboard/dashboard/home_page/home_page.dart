import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';

import '../../../routes/router.gr.dart';

@RoutePage()
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  AdminHomePageLogic adminHomePageLogic = AdminHomePageLogic();

  Future<void> logout(BuildContext ctx) async {
    await logoutAdmin();
    // ignore: use_build_context_synchronously
    ctx.pushRoute(const SignInDashboardPage());
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
            ? const CircularProgressIndicator()
            : Container(
                margin: const EdgeInsets.only(top: 70),
                width: 800,
                child: Column(
                  children: [
                    Text('Welcome ${adminHomePageLogic.admin!.fullName}', style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ActionCard(title: 'All Users', icon: Icons.people, onTap: () => context.pushRoute(const AdminAllUsersPage())),
                        ActionCard(title: 'All Templates', icon: Icons.format_list_bulleted, onTap: () => {context.pushRoute(const AllTemplatesPage())}),
                        ActionCard(title: 'Subscription Settings', icon: Icons.settings, onTap: () => context.pushRoute(const AdminSubscriptionSettingPage())),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ActionCard(title: 'Update Password', icon: Icons.password, onTap: () => context.pushRoute(const AdminChangePasswordPage())),
                        ActionCard(title: 'Contact Us Messages', icon: Icons.message, onTap: () => context.pushRoute(const AdminContactUsPage())),
                        ActionCard(title: 'Sign Out', icon: Icons.logout, onTap: () => logout(context)),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 35, 20, 35),
          child: SizedBox(
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.blue),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
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
