import 'dart:async';

import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashbaord.controller.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard-body.dart';
import 'package:cvworld/client/shared/confirmation-dialog/confirmation-dialog.dart';
import 'package:cvworld/config.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: const DashboardDrawer(),
      body: const SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10), child: DashboardBodyContent(resumeWidth: 200)),
      ),
      floatingActionButton: const FabWithMiniButtons(),
    );
  }
}

class FabWithMiniButtons extends StatelessWidget {
  const FabWithMiniButtons({super.key});

  void quickResume(BuildContext context) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? templateName = await storage.read(key: 'DefaultTemplate');
    // ignore: use_build_context_synchronously
    templateName == null ? context.pushNamed(RouteNames.dashboardTemplates) : context.pushNamed(RouteNames.cvMaker, pathParameters: {"templateName": templateName, "resumeID": "0"});
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.quickreply),
                    title: const Text('Quick Add'),
                    onTap: () {
                      quickResume(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add'),
                    onTap: () {
                      context.pushNamed(RouteNames.dashboardTemplates);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({super.key});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  DashboardController controller = DashboardController();

  bool isLoading = true;
  bool isSubscriber = false;
  User? user;
  StreamSubscription? _subscription;
  StreamSubscription? _userSubscription;
  StreamSubscription? _subscription2;

  @override
  void initState() {
    super.initState();

    _userSubscription = controller.getUser().listen((event) {
      if (mounted) {
        setState(() {
          user = event.data.isNotEmpty ? event.data[0] : null;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });

    _subscription = controller.isSubscribed().listen((event) {
      if (mounted) {
        setState(() {
          isSubscriber = event;
        });
      }
    });

    _subscription2 = ApplicationToken.getInstance().observable.listen((event) {
      if (event == null) {
        context.goNamed(RouteNames.signin);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _userSubscription?.cancel();
    _subscription2?.cancel();
    super.dispose();
  }

  _signOut() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: "Are you sure?",
        message: "Are you sure you want to sign out?",
        confirmButtonText: "Yes",
        cancelButtonText: "No",
        onConfirm: () {
          ApplicationToken.getInstance().deleteToken();
        },
        onCancel: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: ProfileWidget(fullName: user?.fullName ?? '', imageUrl: user?.profilePicture != null ? NetworkApi.publicResource(user!.profilePicture!) : 'https://picsum.photos/200', isPremium: isSubscriber),
                ),
                DrawerMenuItem(
                  icon: Icons.settings,
                  title: 'Account Settings',
                  onTap: () {
                    context.pushNamed(RouteNames.dashboardAccount);
                  },
                ),
                // My Data
                DrawerMenuItem(
                  icon: Icons.person,
                  title: 'My Data',
                  onTap: () {
                    context.pushNamed(RouteNames.dashboardAccountSetting);
                  },
                ),
                // Transactions
                DrawerMenuItem(
                    icon: Icons.monetization_on,
                    title: 'Transactions',
                    onTap: () {
                      context.pushNamed(RouteNames.dashboardTransactions);
                    }),
                // Templates
                DrawerMenuItem(
                    icon: Icons.description,
                    title: 'Templates',
                    onTap: () {
                      context.pushNamed(RouteNames.dashboardTemplates);
                    }),
                const Divider(),
                DrawerMenuItem(
                  icon: Icons.mail,
                  title: 'Contact Us',
                  onTap: () {
                    kIsWeb ? context.pushNamed(RouteNames.dashboardContactUs) : context.pushNamed(RouteNames.contactUs);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    _signOut();
                  },
                ),
                const SizedBox(height: 20),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('App Version: ${ApplicationConfiguration.appVersion}', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItem({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String fullName;
  final bool isPremium;

  const ProfileWidget({
    super.key,
    required this.imageUrl,
    required this.fullName,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 25),
        const SizedBox(height: 5),
        Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        isPremium
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Premium',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
            : GestureDetector(
                onTap: () {
                  context.pushNamed(RouteNames.dashboardAccountSetting);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Upgrade',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ],
    );
  }
}
