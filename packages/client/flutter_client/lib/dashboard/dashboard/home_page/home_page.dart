import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  void onAllUsersTap() {
    // TODO: Implement navigation to All Users screen
    print('All Users tapped');
  }

  void onAllTemplatesTap() {
    // TODO: Implement navigation to All Templates screen
    print('All Templates tapped');
  }

  void onSubscriptionSettingsTap() {
    // TODO: Implement navigation to Subscription Settings screen
    print('Subscription Settings tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          width: 800,
          child: Column(
            children: [
              // Big Text Wriiten , "Welcome Admin"
              const Text(
                'Welcome Admin',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              // List some actions card rectangular, with white background , one logo image center and below a text action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionCard(
                    title: 'All Users',
                    icon: Icons.people,
                    onTap: onAllUsersTap,
                  ),
                  ActionCard(
                    title: 'All Templates',
                    icon: Icons.format_list_bulleted,
                    onTap: onAllTemplatesTap,
                  ),
                  ActionCard(
                    title: 'Subscription Settings',
                    icon: Icons.settings,
                    onTap: onSubscriptionSettingsTap,
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActionCard(
                    title: 'Update Password',
                    icon: Icons.password,
                    onTap: onSubscriptionSettingsTap,
                  ),
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
                Icon(
                  icon,
                  size: 48,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
