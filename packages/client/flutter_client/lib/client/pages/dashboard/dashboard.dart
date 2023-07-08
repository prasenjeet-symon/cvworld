import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/dashboard/dashboard-body.dart';
import 'package:flutter_client/client/pages/dashboard/header.dart';

@RoutePage()
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const DashboardMobile();
      } else {
        return const DashboardDesktop();
      }
    });
  }
}

// Dashboard for desktop
class DashboardDesktop extends StatelessWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DashboardHeader(),
            DashboardBody(),
          ],
        ),
      ),
    );
  }
}

// Dashboard for mobile
class DashboardMobile extends StatelessWidget {
  const DashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
