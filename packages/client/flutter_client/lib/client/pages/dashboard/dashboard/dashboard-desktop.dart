import 'package:flutter/material.dart';
import 'package:cvworld/client/pages/dashboard/components/header.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard-body.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dashboard header for desktop only
            DashboardHeader(),
            const Padding(
              padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
              child: DashboardHeaderSecondary(),
            ),
            const DashboardBodyContent(resumeWidth: 200)
          ],
        ),
      ),
    );
  }
}
