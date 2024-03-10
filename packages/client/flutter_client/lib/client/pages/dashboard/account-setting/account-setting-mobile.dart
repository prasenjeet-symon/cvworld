import 'package:cvworld/client/pages/dashboard/account-setting/account-setting.dart';
import 'package:flutter/material.dart';

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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('My Data'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: AccountSettingBody(),
        ),
      ),
    );
  }
}
