import 'package:cvworld/client/pages/dashboard/account-page/account-page.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class AccountPageWeb extends StatelessWidget {
  const AccountPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Main Content
              Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: MediaQuery.of(context).size.width * ApplicationConfiguration.pageContentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back Button
                      BackButtonApp(onPressed: () => Navigator.pop(context)),
                      // Profile Section
                      AccountPageProfile(),
                      const SizedBox(height: 30),
                      AccountPageDetails(),
                      const SizedBox(height: 30),
                      AccountPagePayment(),
                      const SizedBox(height: 30),
                      AccountPageDelete()
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
