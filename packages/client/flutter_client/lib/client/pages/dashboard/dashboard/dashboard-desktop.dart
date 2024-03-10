import 'package:cvworld/client/pages/dashboard/components/header.dart';
import 'package:cvworld/client/shared/dashboard-header/dashboard-header.dart' as M;
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard-body.dart';
import 'package:flutter/material.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            M.DashboardHeader(),
            Padding(padding: EdgeInsets.fromLTRB(100, 10, 100, 10), child: DashboardHeaderSecondary()),
            DashboardBodyContent(resumeWidth: 200),
          ],
        ),
      ),
    );
  }
}
