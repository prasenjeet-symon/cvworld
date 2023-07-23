import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/dashboard/profile.dart';
import 'package:flutter_client/routes/router.gr.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const DashboardHeaderMobile();
      } else {
        return const DashboardHeaderDesktop();
      }
    });
  }
}

class DashboardHeaderMobile extends StatelessWidget {
  const DashboardHeaderMobile({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class DashboardHeaderDesktop extends StatefulWidget {
  const DashboardHeaderDesktop({super.key});

  @override
  State<DashboardHeaderDesktop> createState() => _DashboardHeaderDesktopState();
}

class _DashboardHeaderDesktopState extends State<DashboardHeaderDesktop> {
  User? user;

  // Fetch the user
  Future<void> fetchUser() async {
    user = await DatabaseService().fetchUser();
  }

  @override
  void initState() {
    super.initState();
    fetchUser().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.4),
            width: 0.4,
          ),
        ),
      ),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              !(user.isDefinedAndNotNull && user!.subscription.isDefinedAndNotNull && user!.subscription!.isActive)
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: ElevatedButton(
                        onPressed: () => {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Set the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4.0,
                            ), // Set the button border radius
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => context.pushRoute(const AccountSettingPage()),
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
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              const ProfileOptions()
            ],
          )
        ],
      ),
    );
  }
}
