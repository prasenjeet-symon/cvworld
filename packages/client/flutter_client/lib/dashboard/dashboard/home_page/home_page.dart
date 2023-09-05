import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../routes/router.gr.dart';

@RoutePage()
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          width: 800,
          child: Column(
            children: [
              const Text(
                'Welcome Admin',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
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
                  // Contact Us Messages
                  ActionCard(title: 'Contact Us Messages', icon: Icons.message, onTap: () => context.pushRoute(const AdminContactUsPage())),
                  ActionCard(title: 'Sign Out', icon: Icons.logout, onTap: () => context.pushRoute(const SignInDashboardPage())),
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
