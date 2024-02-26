import 'package:cvworld/client/pages/dashboard/account-page/account-page.mobile.dart';
import 'package:cvworld/client/pages/dashboard/account-page/account-page.web.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        // Mobile
        return const AccountPageMobile();
      } else {
        // Desktop
        return const AccountPageWeb();
      }
    });
  }
}

///
///
///
/// Account page profile
class AccountPageProfile extends StatelessWidget {
  const AccountPageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/200'),
              minRadius: 70,
              maxRadius: 70,
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('John Doe', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Chip(label: Text('Premium'), backgroundColor: Colors.green, labelStyle: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text('CvZG5@example.com', style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            flex: 6,
          ),
          Expanded(
            child: Container(
              height: 40,
              width: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {},
                child: Text('Sign Out'),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

///
///
///
/// Account Page Details
class AccountPageDetails extends StatelessWidget {
  const AccountPageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Text('Account Details', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            // Content
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Column(
                children: [
                  // Each row of content
                  Container(
                    // border bottom
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), flex: 6),
                        Text('John Doe', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  ),

                  Container(
                    // border bottom
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Username', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), flex: 6),
                        Text('johndoe134', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  ),

                  Container(
                    // border bottom
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), flex: 6),
                        Text('CvZG5@example.com', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  ),

                  Container(
                    // border bottom
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(child: Text('Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), flex: 6),
                        Text('********', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.end),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

///
///
///
/// Account payment details
class AccountPagePayment extends StatelessWidget {
  final bool isPremium;

  const AccountPagePayment({super.key, this.isPremium = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Text('Membership Details', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            // Content
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment description with pricing
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        'Premium members get access to all premium templates forever with a monthly subscription of \$${ApplicationConfiguration.subscriptionPrice}. You can cancel anytime',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  isPremium
                      ? TextButton(onPressed: () {}, child: const Text('Cancel'))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {},
                          child: const Text('Upgrade', style: TextStyle(fontSize: 15, color: Colors.white)),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

///
///
///
/// Delete account
class AccountPageDelete extends StatelessWidget {
  const AccountPageDelete({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: Colors.red.shade50,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Text('Delete Account', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
            ),
            // Content
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment description with pricing
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        'Are you sure you want to delete your account? This action cannot be undone',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {},
                    child: const Text('Delete', style: TextStyle(fontSize: 15, color: Colors.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
