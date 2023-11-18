import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/pages/dashboard/account-setting/account-setting.dart';

class AccountSettingMobile extends StatefulWidget {
  const AccountSettingMobile({super.key});

  @override
  State<AccountSettingMobile> createState() => _AccountSettingMobileState();
}

class _AccountSettingMobileState extends State<AccountSettingMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Add your action here
            context.popRoute(const AccountSettingPage());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Account Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: AccountSettingBody(),
        ),
      ),
    );
  }
}
