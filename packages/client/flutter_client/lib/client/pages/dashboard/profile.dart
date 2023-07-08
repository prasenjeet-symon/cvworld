import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';

class ProfileOptions extends StatefulWidget {
  const ProfileOptions({super.key});

  @override
  State<ProfileOptions> createState() => _ProfileOptionsState();
}

class _ProfileOptionsState extends State<ProfileOptions> {
  User? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonalDetails();
  }

  // fetch user details
  Future<void> fetchPersonalDetails() async {
    isLoading = true;
    setState(() {});
    var userDetailsFetched = await DatabaseService().fetchUser();
    userDetails = userDetailsFetched;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        // Header name
        PopupMenuItem(value: 'profile', child: ListTile(leading: const Icon(Icons.verified_user), title: Text(isLoading ? '' : userDetails!.fullName, style: const TextStyle(fontWeight: FontWeight.w700)))),
        const PopupMenuItem(value: 'dashboard', child: ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard'))),
        const PopupMenuItem(value: 'account_settings', child: ListTile(leading: Icon(Icons.settings), title: Text('Account Settings'))),
        const PopupMenuItem(value: 'logout', child: ListTile(leading: Icon(Icons.logout), title: Text('Logout'))),
      ],
      onSelected: (value) {
        switch (value) {
          case 'account_settings':
            context.pushRoute(const AccountSettingPage());
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
      child: isLoading
          ? const CircularProgressIndicator()
          : CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userDetails!.profilePicture), // Replace with your profile image
            ),
    );
  }
}
