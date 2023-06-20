import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';

class ProfileOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'dashboard',
          child: ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
        ),
        const PopupMenuItem(
          value: 'account_settings',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Account Settings'),
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'account_settings':
            // Handle Account Settings option tap
            break;
          case 'logout':
            logOutUser(context);
            break;
          case 'dashboard':
            // Handle Dashboard option tap
            context.navigateNamedTo('/dashboard');
            break;
        }
      },
      child: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
            'https://th.bing.com/th/id/R.c514937c5ef07071b3d6c9984b648c20?rik=UNQGgTGQ8E0HQA&riu=http%3a%2f%2feskipaper.com%2fimages%2fcute-little-girl-1.jpg&ehk=%2fDMWrtZylAY6C3OhXhir9YgdO3by%2ffAHtlvlfnmD5L0%3d&risl=&pid=ImgRaw&r=0'), // Replace with your profile image
      ),
    );
  }
}
