import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/pages/dashboard/account-page/account-page.dart';
import 'package:cvworld/client/shared/confirmation-dialog/confirmation-dialog.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class AccountPageMobile extends StatefulWidget {
  const AccountPageMobile({super.key});

  @override
  State<AccountPageMobile> createState() => _AccountPageMobileState();
}

class _AccountPageMobileState extends State<AccountPageMobile> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        actions: [IconButton(onPressed: () => _signOut(), icon: const Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Main Content
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AccountPageProfile(),
                      const SizedBox(height: 30),
                      AccountPageDetails(),
                      const SizedBox(height: 30),
                      AccountPagePayment(),
                      const SizedBox(height: 30),
                      AccountPageDelete(),
                    ],
                  ),
                ),
              )
              // Footer section if needed
            ],
          ),
        ),
      ),
    );
  }
}
