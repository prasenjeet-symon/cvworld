import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/components/profile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late final DashboardHeaderLogic dashboardHeaderLogic;

  @override
  void initState() {
    super.initState();
    dashboardHeaderLogic = DashboardHeaderLogic(setStateCallback: _updateState);
    dashboardHeaderLogic.fetchUser();

    MySubjectSingleton.instance.dashboardHeaderSubject.listen((value) {
      if (value) {
        dashboardHeaderLogic.fetchUser(enableLoading: false);
      }
    });
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dashboardHeaderLogic.isLoading || dashboardHeaderLogic.user == null) {
      return _buildLoadingHeader();
    }

    return _buildDashboardHeader(context, dashboardHeaderLogic.user!);
  }

  Widget _buildLoadingHeader() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.4))),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context, User user) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.4))),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              if (!(user.subscription?.isActive ?? false)) _buildUpgradeButton(context),
              const ProfileOptions(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: ElevatedButton(
        onPressed: () => context.pushNamed(RouteNames.dashboardAccountSetting),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Set the button color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.upcoming_rounded),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text('Upgrade Now', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeaderSecondary extends StatelessWidget {
  const DashboardHeaderSecondary({super.key});

  void quickResume(BuildContext context) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? templateName = await storage.read(key: 'DefaultTemplate');
    // ignore: use_build_context_synchronously
    templateName == null ? context.pushNamed(RouteNames.dashboardTemplates) : context.pushNamed(RouteNames.cvMaker, pathParameters: {"templateName": templateName, "resumeID": "0"});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.4))),
      margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: Row(
        children: [
          const Expanded(child: Text('Resumes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
          // Quick create button
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20)),
            onPressed: () {
              quickResume(context);
            },
            child: const Row(
              children: [Icon(Icons.quickreply), Text('Quick Create')],
            ),
          ),
          // Full create button
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20)),
            onPressed: () => context.pushNamed(RouteNames.dashboardTemplates),
            child: const Row(
              children: [Icon(Icons.add), Text('Create')],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardHeaderLogic {
  User? user;
  Function() setStateCallback; // Callback to call setState in the parent widget
  bool isLoading = true;

  DashboardHeaderLogic({required this.setStateCallback});

  Future<User?> fetchUser({bool enableLoading = true}) async {
    isLoading = enableLoading;
    setStateCallback(); // Trigger UI update to show loading indicator

    user = await DatabaseService().fetchUser();

    isLoading = false;
    setStateCallback(); // Trigger UI update with fetched user data
    return user;
  }
}
