import 'dart:async';
import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/dashboard/header.dart';
import 'package:flutter_client/client/pages/make-cv-pages/courses-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/education-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/employment-history-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/hobbie-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/internship-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/language-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/personal-details-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/professional-summry-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/skills-section.dart';
import 'package:flutter_client/client/pages/make-cv-pages/website-links-section.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DashboardHeader(),
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
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            child: Row(children: [
                              // ignore: deprecated_member_use
                              BackButtonApp(onPressed: () {
                                context.popRoute(AccountSettingPage());
                              }),
                              Expanded(child: SizedBox()),
                            ])),
                        const PricingPlanCard(),
                        const AccountCard(),
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
class PricingPlanCard extends StatefulWidget {
  const PricingPlanCard({super.key});

  @override
  State<PricingPlanCard> createState() => _PricingPlanCardState();
}

class _PricingPlanCardState extends State<PricingPlanCard> {
  SubscriptionPlan? subscriptionPlan;
  User? user;
  bool isLoading = true;
  late Timer? timer;

  // Fetch the user
  Future<void> fetchUser() async {
    user = await DatabaseService().fetchUser();
  }

  /// Fetch all the plans
  Future<void> fetchAllPlans() async {
    var subsPlan = await DatabaseService().getPremiumPlan();
    subscriptionPlan = subsPlan;
    return;
  }

  /// Subscribe to premium
  Future<String?> subscribeToPremium(SubscriptionPlan plan) async {
    isLoading = true;
    setState(() {});
    var link = await DatabaseService().createSubscription(plan.name);
    isLoading = false;
    setState(() {});
    return link;
  }

  /// init the subs checking
  Future<void> startTick() async {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      // This function will be called every 5 second
      this.timer = timer;
      await fetchUser();
      setState(() {});
    });
  }

  /// Subscribe to premium
  Future<void> subscribeNow() async {
    startTick();
    if (kIsWeb) {
      // open the new tab
      var link = await subscribeToPremium(subscriptionPlan!);
      openLinkInBrowser(link ?? '');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    setState(() {});
    fetchUser().then((value) => fetchAllPlans()).then(
          (value) => setState(
            () {
              isLoading = false;
            },
          ),
        );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 45, 0, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text(
              'YOUR PLAN',
              style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500),
            ),
          ),
          user.isDefinedAndNotNull && user!.subscription.isDefinedAndNotNull && user!.subscription!.isActive
              ? Container(
                  color: Colors.black.withOpacity(0.03),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: [
                      SizedBox(width: 50, height: 50, child: Image.asset('assets/tasks.png')),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.subscription!.planName,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: const Text(
                                'You are on premium plan. You can use any resume template',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      )),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.black.withOpacity(0.03),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/renew.png'),
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Free Plan',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: const Text(
                                'You are on the free plan. You can use free resume template only.Upgrade for PDF downloads & premium templates.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      )),
                      TextButton(
                        onPressed: () {
                          subscribeNow();
                        },
                        child: const Text(
                          'Upgrade',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          children: [
            Column(children: [PersonalDetailSection(title: 'Personal Details', description: '')]),
            Column(children: [ProfessionalSummary(title: 'Professional Summary', description: '')]),
            Column(children: [EmploymentHistorySection(title: 'Employment History', description: '')]),
            Column(children: [EducationSection(title: 'Education', description: '')]),
            Column(children: [WebsiteLinkSection(title: 'Website Links', description: '')]),
            Column(children: [SkillSection(title: 'Skills Section', description: '')]),
            Column(children: [HobbiesSection(title: 'Hobby Section', description: '')]),
            Column(children: [InternshipSection(title: 'Internship', description: '')]),
            Column(children: [CourseSection(title: 'Courses', description: '')]),
            Column(children: [LanguageSection(title: 'Languages', description: '')]),
          ],
        )
      ]),
    );
  }
}

///
///
///
///
///
///
///
///
///
class AccountSettingMobile extends StatefulWidget {
  const AccountSettingMobile({super.key});

  @override
  State<AccountSettingMobile> createState() => _AccountSettingMobileState();
}

class _AccountSettingMobileState extends State<AccountSettingMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SingleChildScrollView(child: Column(children: [])));
  }
}
