import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';

@RoutePage()
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          width: 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BackButtonApp(onPressed: () {
                context.popRoute(const UserProfilePage());
              }),
              const SizedBox(height: 60),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                // circular image
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                  ),
                  radius: 50,
                ),
                const SizedBox(height: 35),
                const Text(
                  'User Name',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 35),
                // is subscriber
                const Text(
                  'Subscriber',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                // border line
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                  indent: 50,
                  endIndent: 50,
                ),

                // List all the bought template
                Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  // Heading "Bought Templates"
                  const Text(
                    'Bought Templates',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 35),
                  // list all the bought template card with image and title and price in rupee
                ])
              ])
            ],
          ),
        ),
      ),
    );
  }
}
