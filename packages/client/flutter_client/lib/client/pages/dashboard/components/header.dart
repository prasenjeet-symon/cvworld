import 'package:auto_route/auto_route.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/components/profile.dart';
import 'package:cvworld/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

// Business Logic Class for DashboardHeader
class DashboardHeaderLogic {
  User? user;
  Function() setStateCallback; // Callback to call setState in the parent widget
  bool isLoading = true;

  DashboardHeaderLogic({required this.setStateCallback});

  Future<User?> fetchUser() async {
    isLoading = true;
    setStateCallback(); // Trigger UI update to show loading indicator
    user = await DatabaseService().fetchUser();
    isLoading = false;
    setStateCallback(); // Trigger UI update with fetched user data
    return user;
  }
}

class DashboardHeader extends StatefulWidget {
  BehaviorSubject<bool>? canRefresh;

  DashboardHeader({super.key, this.canRefresh});

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

    if (widget.canRefresh != null) {
      widget.canRefresh!.listen((event) {
        if (event) {
          dashboardHeaderLogic.fetchUser();
        }
      });
    }
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dashboardHeaderLogic.isLoading) {
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
              if (!(user.subscription != null) || !user.subscription!.isActive) _buildUpgradeButton(context),
              ProfileOptions(canRefresh: widget.canRefresh),
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
        onPressed: () => context.pushRoute(const AccountSettingPage()),
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
                child: Text(
                  'Upgrade Now',
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.white),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.4))),
      margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: Row(
        children: [
          const Expanded(child: Text('Resumes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(40, 20, 40, 20)),
            onPressed: () => context.pushRoute(const MarketPlacePage()),
            child: const Row(
              children: [Icon(Icons.add), Text('Create')],
            ),
          ),
        ],
      ),
    );
  }
}
