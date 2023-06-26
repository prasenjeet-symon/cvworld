import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/make-cv-pages/personal-details-section.dart';

@RoutePage()
class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      if (constraint.maxWidth > 600) {
        return const AccountSettingDesktop();
      } else {
        return const AccountSettingMobile();
      }
    });
  }
}

class AccountSettingDesktop extends StatefulWidget {
  const AccountSettingDesktop({super.key});

  @override
  State<AccountSettingDesktop> createState() => _AccountSettingDesktopState();
}

class _AccountSettingDesktopState extends State<AccountSettingDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PricingPlanCard(),
                        AccountCard(),
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: slash_for_doc_comments
/** 
 * 
 * Pricing plan card
 * 
 * 
 */
class PricingPlanCard extends StatelessWidget {
  const PricingPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 45, 0, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text(
              'YOUR PLAN',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.03),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    '/renew.png',
                  ),
                ),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Free Plan',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: const Text(
                          'You are on the free plan. You can save your data and search for jobs. Upgrade for PDF downloads & premium features.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Upgrade',
                      style: TextStyle(fontSize: 16),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: [
            const PersonalDetailSection(
                title: 'Personal Details', description: ''),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 20),
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15)),
                      onPressed: () {},
                      child: const Text('Save')),
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}

class AccountSettingMobile extends StatefulWidget {
  const AccountSettingMobile({super.key});

  @override
  State<AccountSettingMobile> createState() => _AccountSettingMobileState();
}

class _AccountSettingMobileState extends State<AccountSettingMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(child: Column(children: [])));
  }
}
