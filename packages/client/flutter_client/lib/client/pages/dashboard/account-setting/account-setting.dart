import 'dart:async';

import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/account-setting/account-setting-mobile.dart';
import 'package:cvworld/client/pages/make-cv-pages/courses-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/education-section.dart' show EducationSection;
import 'package:cvworld/client/pages/make-cv-pages/employment-history-section.dart' show EmploymentHistorySection;
import 'package:cvworld/client/pages/make-cv-pages/hobbie-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/internship-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/language-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/personal-details-section.dart' show PersonalDetailSection;
import 'package:cvworld/client/pages/make-cv-pages/professional-summry-section.dart' show ProfessionalSummary;
import 'package:cvworld/client/pages/make-cv-pages/skills-section.dart';
import 'package:cvworld/client/pages/make-cv-pages/website-links-section.dart' show WebsiteLinkSection;
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'account-setting-desktop.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        // Mobile
        return const AccountSettingMobile();
      } else {
        // Desktop
        return const AccountSettingDesktop();
      }
    });
  }
}

///
///
///
///
///
class PricingPlanCardLogic {
  SubscriptionPlan? subscriptionPlan;
  User? user;
  bool isLoading = true;
  Timer? timer;
  final Function setStateCallback;

  PricingPlanCardLogic({required this.setStateCallback});

  Future<void> fetchUser({bool enableLoading = true}) async {
    isLoading = enableLoading;
    setStateCallback();

    user = await DatabaseService().fetchUser();

    isLoading = false;
    setStateCallback();
  }

  Future<void> fetchAllPlans() async {
    isLoading = true;
    setStateCallback();

    var subsPlan = await DatabaseService().getPremiumPlan();
    subscriptionPlan = subsPlan;

    isLoading = false;
    setStateCallback();
    return;
  }

  Future<String?> subscribeToPremium(SubscriptionPlan plan) async {
    isLoading = true;
    setStateCallback();

    var link = await DatabaseService().createSubscription(plan.name);

    isLoading = false;
    setStateCallback();
    return link;
  }

  Future<void> startTick(Function callback) async {
    timer = Timer.periodic(const Duration(seconds: Constants.refreshSeconds), (Timer timer) {
      _fetchUserAndSetState(callback);
    });

    TimerHolder().addTimer(timer);
  }

  Future<void> _fetchUserAndSetState(Function callback) async {
    try {
      await fetchUser(enableLoading: false);
      setStateCallback();

      // If user is a subscriber
      if (user?.subscription?.isActive ?? false) {
        timer?.cancel();
        callback();
      }
    } catch (error) {
      timer?.cancel();
      // Handle errors, log, or take appropriate action
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> subscribeNow(Function callback) async {
    timer?.cancel();
    startTick(callback);

    var link = await subscribeToPremium(subscriptionPlan!);

    if (link == null) {
      timer?.cancel();
    }

    openLinkInBrowser(link ?? '');
  }

  // cancel the subscription
  Future<void> cancelSubscription() async {
    startTick(() {});
    await DatabaseService().cancelSubscription();
    timer?.cancel();
  }

  void dispose() {
    timer?.cancel();
  }
}

///
///
///
class AccountDeleteCardLogic {
  bool isLoading = true;

  AccountDeleteCardLogic();

  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;
    await DatabaseService().deleteUser();
    isLoading = false;

    // Logout
    DatabaseService().logout().then((value) => context.pushNamed(RouteNames.signin));
  }
}

///
///
///
///
///
class PlanCardWidget extends StatelessWidget {
  final String planName;
  final String description;
  final bool isPremium;
  final void Function() onPressed;

  const PlanCardWidget({
    super.key,
    required this.planName,
    required this.description,
    required this.isPremium,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.03),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 50, height: 50, child: Image.asset(isPremium ? 'assets/tasks.png' : 'assets/renew.png')),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    planName,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(description, style: const TextStyle(color: Colors.black54)),
                  ),
                  const SizedBox(height: 10),
                  isPremium
                      ? TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          ),
                          onPressed: onPressed,
                          child: const Text('Cancel'),
                        )
                      : TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            elevation: 0,
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          ),
                          onPressed: onPressed,
                          child: const Text('Upgrade'),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///
///
///
///

class AccountDeleteCardWidget extends StatefulWidget {
  final void Function() onPressed;

  const AccountDeleteCardWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AccountDeleteCardWidgetState createState() => _AccountDeleteCardWidgetState();
}

class _AccountDeleteCardWidgetState extends State<AccountDeleteCardWidget> {
  final AccountDeleteCardLogic _logic = AccountDeleteCardLogic();

  Future<void> _showDeleteAccountConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account', textAlign: TextAlign.center),
          content: const SingleChildScrollView(
            child: Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to delete account
                widget.onPressed();
                _logic.deleteAccount(context);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: Text('DELETE ACCOUNT', style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500)),
        ),
        Container(
          color: Colors.black.withOpacity(0.03),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset('assets/delete_account.png'), // You can change the image asset as per your requirement
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete Account',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Are you sure you want to delete your account? This action cannot be undone.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        ),
                        onPressed: () {
                          _showDeleteAccountConfirmation(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

///
///
///
///
class PricingPlanCard extends StatefulWidget {
  const PricingPlanCard({super.key});

  @override
  State<PricingPlanCard> createState() => _PricingPlanCardState();
}

class _PricingPlanCardState extends State<PricingPlanCard> {
  late final PricingPlanCardLogic logic;

  stateCallback() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    logic = PricingPlanCardLogic(setStateCallback: stateCallback);
    logic.fetchUser().then((value) => logic.fetchAllPlans());
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  Future<void> _showCancelSubscriptionPopup(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Subscription', textAlign: TextAlign.center),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to cancel your subscription?', textAlign: TextAlign.center),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to cancel subscription
                logic.cancelSubscription();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showGreetingPopup(BuildContext context) async {
    MySubjectSingleton.instance.dashboardHeaderSubject.add(true);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thank you for becoming a Premium Member.', textAlign: TextAlign.center),
              const SizedBox(height: 20.0),
              Image.asset(
                'assets/premium_member_image.png', // Replace with your premium member image asset
                height: 100.0,
                width: 100.0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (logic.isLoading) {
      // Shrink
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text('YOUR PLAN', style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500)),
          ),
          logic.user?.subscription?.isActive ?? false
              ? PlanCardWidget(
                  planName: logic.user!.subscription!.planName,
                  description: 'You are on premium plan. You can use any resume template',
                  isPremium: true,
                  onPressed: () {
                    _showCancelSubscriptionPopup(context);
                  },
                )
              : PlanCardWidget(
                  planName: 'Free Plan',
                  description: 'You are on the free plan. You can use free resume template only. Upgrade for PDF downloads & premium templates.',
                  isPremium: false,
                  onPressed: () => logic.subscribeNow(
                    () {
                      _showGreetingPopup(context);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

///
///
///
///
///
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
class AccountSettingBody extends StatelessWidget {
  const AccountSettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          SizedBox(
            width: isMobile ? MediaQuery.of(context).size.width * 0.915 : MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMobile)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Row(
                      children: [
                        BackButtonApp(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                const PricingPlanCard(),
                const ImageCard(),
                AccountDeleteCardWidget(onPressed: () {}),
                const AccountCard(),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
