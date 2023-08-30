import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

@RoutePage()
class AdminSubscriptionSettingPage extends StatefulWidget {
  const AdminSubscriptionSettingPage({super.key});

  @override
  State<AdminSubscriptionSettingPage> createState() => _AdminSubscriptionSettingPageState();
}

class _AdminSubscriptionSettingPageState extends State<AdminSubscriptionSettingPage> {
  final AdminSubscriptionSettingsLogic adminSubscriptionSettingLogic = AdminSubscriptionSettingsLogic();
  late String planID;

  @override
  void initState() {
    super.initState();
    adminSubscriptionSettingLogic.fetchAllTemplatePlans(setState).then(
          (value) => {
            if (value != null) {planID = value}
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BackButtonApp(onPressed: () {
                context.popRoute(const AdminSubscriptionSettingPage());
              }),
              const SizedBox(height: 60),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Big text "Subscription Settings"
                  const Text(
                    'Subscription Setting',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 35),
                  // Subscription Settings name field
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subscription Name',
                      hintText: 'Enter your subscription name',
                    ),
                    keyboardType: TextInputType.text,
                    controller: adminSubscriptionSettingLogic.subscriptionNameController,
                  ),
                  const SizedBox(height: 10),
                  // Subscription Settings price field
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subscription Price',
                      hintText: 'Enter your subscription price in paisa',
                    ),
                    keyboardType: TextInputType.number,
                    controller: adminSubscriptionSettingLogic.subscriptionPriceController,
                  ),
                  const SizedBox(height: 10),
                  // Subscription Settings description field
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Subscription Description',
                      hintText: 'Enter your subscription description',
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    controller: adminSubscriptionSettingLogic.subscriptionDescriptionController,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      adminSubscriptionSettingLogic.saveSubscription(planID);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                      backgroundColor: Colors.blue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    child: const Text('Save Settings'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AdminSubscriptionSettingsLogic {
  // subscription name
  final TextEditingController subscriptionNameController = TextEditingController();
  // subscription price
  final TextEditingController subscriptionPriceController = TextEditingController();
  // subscription description
  final TextEditingController subscriptionDescriptionController = TextEditingController();

  // save subscription
  Future<void> saveSubscription(String planID) async {
    var subscriptionName = subscriptionNameController.text;
    var subscriptionPrice = int.parse(subscriptionPriceController.text);
    var subscriptionDescription = subscriptionDescriptionController.text;

    // check for the subscription
    if (subscriptionName.isEmpty || subscriptionPriceController.text.isEmpty) {
      return;
    }

    // save
    await DashboardDataService().updateTemplatePlan(planID, subscriptionPrice, subscriptionName, subscriptionDescription);
    Fluttertoast.showToast(msg: 'Subscription Updated', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white);
  }

  // Fetch all the template plans receive the set state
  Future<String?> fetchAllTemplatePlans(void Function(void Function()) setState) async {
    // fetch
    var response = await DashboardDataService().getPremiumPlan();
    // choose only one
    if (response != null && response.isNotEmpty) {
      var plan = response[0];
      subscriptionNameController.text = plan.name;
      subscriptionPriceController.text = plan.price.toString();
      subscriptionDescriptionController.text = plan.description;

      setState(() {});
      return plan.planID;
    } else {
      return null;
    }
  }
}
