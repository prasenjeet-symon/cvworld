import 'dart:async';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/shared/dashboard-header/dashboard-header.controller.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  DashboardHeaderController controller = DashboardHeaderController();

  User? user;
  StreamSubscription? _subscription;
  bool isLoading = true;
  StreamSubscription? _subscription2;

  @override
  void initState() {
    super.initState();

    _subscription = controller.getUser().listen((event) {
      if (mounted) {
        setState(() {
          user = event.data.isNotEmpty ? event.data[0] : null;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });

    _subscription2 = ApplicationToken.getInstance().observable.listen((event) {
      if (event == null) {
        context.goNamed(RouteNames.signin);
      }
    });
  }

  // Dispose
  @override
  void dispose() {
    _subscription?.cancel();
    _subscription2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(0),
      child: Row(
        children: [
          // Logo here
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Image.asset('assets/logo.png', width: 60, height: 60, fit: BoxFit.fitHeight),
          ),
          const Expanded(child: SizedBox()),
          // Templates
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                context.pushNamed(RouteNames.dashboardTemplates);
              },
              child: const Text('Templates', style: TextStyle(color: Colors.white)),
            ),
          ),
          // Transactions
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                context.pushNamed(RouteNames.dashboardTransactions);
              },
              child: const Text('Transactions', style: TextStyle(color: Colors.white)),
            ),
          ),
          // Contact Menu Item
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                context.pushNamed(RouteNames.dashboardContactUs);
              },
              child: const Text('Contact Us', style: TextStyle(color: Colors.white)),
            ),
          ),
          // Domain
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                context.pushNamed(RouteNames.dashboardDomain);
              },
              child: const Text('Domain', style: TextStyle(color: Colors.white)),
            ),
          ),
          // My Data Menu Item
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                context.pushNamed(RouteNames.dashboardAccountSetting);
              },
              child: const Text('My Data', style: TextStyle(color: Colors.white)),
            ),
          ),
          // Account Menu Item
          GestureDetector(
            onTap: () {
              context.pushNamed(RouteNames.dashboardAccount);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(NetworkApi.publicResource(user?.profilePicture ?? 'https://picsum.photos/200')),
                backgroundColor: Colors.blue,
                child: isLoading ? const CircularProgressIndicator() : null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
