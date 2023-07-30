import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/dashboard/account-setting/account-setting.dart';
import 'package:flutter_client/client/pages/dashboard/components/header.dart';

class AccountSettingDesktop extends StatefulWidget {
  const AccountSettingDesktop({super.key});

  @override
  State<AccountSettingDesktop> createState() => _AccountSettingDesktopState();
}

class _AccountSettingDesktopState extends State<AccountSettingDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [DashboardHeader(), AccountSettingBody()]),
        ),
      ),
    );
  }
}
