import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileOptions extends StatefulWidget {
  const ProfileOptions({super.key});

  @override
  State<ProfileOptions> createState() => _ProfileOptionsState();
}

class _ProfileOptionsState extends State<ProfileOptions> {
  late final ProfileOptionsLogic profileOptionsLogic;

  @override
  void initState() {
    super.initState();
    profileOptionsLogic = ProfileOptionsLogic(setStateCallback: _updateState);
    profileOptionsLogic.fetchPersonalDetails();

    MySubjectSingleton.instance.dashboardHeaderSubject.listen((value) {
      if (value) {
        profileOptionsLogic.fetchPersonalDetails(enableLoading: false);
      }
    });
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleMenuItemSelection(String value) {
    switch (value) {
      case 'account_settings':
        context.pushNamed(RouteNames.dashboardAccountSetting);
        break;
      case 'logout':
        profileOptionsLogic.logOutUser(context);
        break;
      case 'dashboard':
        // Handle Dashboard option tap
        context.pushNamed(RouteNames.dashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => _buildPopupMenuItems(),
      onSelected: _handleMenuItemSelection,
      child: _buildAvatar(),
    );
  }

  List<PopupMenuItem<String>> _buildPopupMenuItems() {
    return [
      _buildProfileMenuItem(),
      _buildDashboardMenuItem(),
      _buildAccountSettingsMenuItem(),
      _buildLogoutMenuItem(),
    ];
  }

  PopupMenuItem<String> _buildProfileMenuItem() {
    return PopupMenuItem(
      value: 'profile',
      child: ListTile(
        leading: const Icon(Icons.verified_user),
        title: Text(profileOptionsLogic.isLoading ? '' : profileOptionsLogic.userDetails!.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  PopupMenuItem<String> _buildDashboardMenuItem() {
    return const PopupMenuItem(
      value: 'dashboard',
      child: ListTile(
        leading: Icon(Icons.dashboard),
        title: Text('Dashboard'),
      ),
    );
  }

  PopupMenuItem<String> _buildAccountSettingsMenuItem() {
    return const PopupMenuItem(
      value: 'account_settings',
      child: ListTile(
        leading: Icon(Icons.settings),
        title: Text('Account Settings'),
      ),
    );
  }

  PopupMenuItem<String> _buildLogoutMenuItem() {
    return const PopupMenuItem(
      value: 'logout',
      child: ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
      ),
    );
  }

  Widget _buildAvatar() {
    return profileOptionsLogic.isLoading
        ? const CircularProgressIndicator()
        : CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(profileOptionsLogic.userDetails!.profilePicture), // Replace with your profile image
          );
  }
}

class ProfileOptionsLogic {
  User? userDetails;
  bool isLoading = true;
  Function() setStateCallback; // Callback to call setState in the parent widget

  ProfileOptionsLogic({required this.setStateCallback});

  // Fetch user details from the database
  Future<void> fetchPersonalDetails({bool enableLoading = true}) async {
    isLoading = enableLoading;
    setStateCallback(); // Trigger UI update to show loading indicator
    userDetails = await DatabaseService().fetchUser();
    isLoading = false;
    setStateCallback(); // Trigger UI update to show user details
  }

  // Log out the user
  void logOutUser(BuildContext context) {
    DatabaseService().logout().then((value) => context.pushNamed(RouteNames.signin));
  }
}
