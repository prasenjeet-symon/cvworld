import 'package:flutter/material.dart';
import 'package:cvworld/client/pages/dashboard/account-setting/account-setting.dart';
import 'package:cvworld/client/pages/dashboard/components/header.dart';
import 'package:rxdart/subjects.dart';

class AccountSettingDesktop extends StatefulWidget {
  const AccountSettingDesktop({super.key});

  @override
  State<AccountSettingDesktop> createState() => _AccountSettingDesktopState();
}

class _AccountSettingDesktopState extends State<AccountSettingDesktop> {
  // init the behavior subject
  BehaviorSubject<bool> canRefresh = BehaviorSubject.seeded(true);

  @override
  void dispose() {
    canRefresh.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            DashboardHeader(canRefresh: canRefresh),
            AccountSettingBody(
              canRefresh: canRefresh,
            )
          ]),
        ),
      ),
    );
  }
}
