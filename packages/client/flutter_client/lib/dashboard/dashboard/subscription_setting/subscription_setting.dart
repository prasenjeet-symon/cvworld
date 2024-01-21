import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/datasource_dashboard.dart';
import 'package:flutter/material.dart';

class AdminSubscriptionSettingPage extends StatefulWidget {
  const AdminSubscriptionSettingPage({super.key});

  @override
  State<AdminSubscriptionSettingPage> createState() => _AdminSubscriptionSettingPageState();
}

class _AdminSubscriptionSettingPageState extends State<AdminSubscriptionSettingPage> {
  final AdminSubscriptionSettingsLogic adminSubscriptionSettingLogic = AdminSubscriptionSettingsLogic();
  late String planID;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = true;
    });

    adminSubscriptionSettingLogic
        .fetchAllTemplatePlans(setState)
        .then(
          (value) => {
            if (value != null) {planID = value}
          },
        )
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
          : Center(
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BackButtonApp(onPressed: () {
                      Navigator.pop(context);
                    }),
                    const SizedBox(height: 60),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Big text "Subscription Settings"
                        const Text('Subscription Settings', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 35),

                        SubscriptionSettingsForm(
                          nameController: adminSubscriptionSettingLogic.subscriptionNameController,
                          priceController: adminSubscriptionSettingLogic.subscriptionPriceController,
                          descriptionController: adminSubscriptionSettingLogic.subscriptionDescriptionController,
                          onSave: () => adminSubscriptionSettingLogic.saveSubscription(context, planID),
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
  Future<void> saveSubscription(BuildContext context, String planID) async {
    var subscriptionName = subscriptionNameController.text;
    var subscriptionPrice = int.parse(subscriptionPriceController.text);
    var subscriptionDescription = subscriptionDescriptionController.text;

    await DashboardDataService().updateTemplatePlan(planID, subscriptionPrice, subscriptionName, subscriptionDescription);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        margin: EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: Center(
          child: Text(
            'Subscription updated successfully!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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

///
///
///
///
///
///

class SubscriptionNameInput extends StatelessWidget {
  final TextEditingController controller;

  const SubscriptionNameInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String? _validateSubscriptionName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a subscription name';
    }

    // Check if the subscription name contains at least 3 characters.
    if (value.length < 3) {
      return 'Subscription name must be at least 3 characters long';
    }

    // Check if the subscription name contains only letters, numbers, and spaces.
    if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return 'Subscription name can only contain letters, numbers, and spaces';
    }

    // You can add more specific validation criteria here if needed.

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Subscription Name',
        hintText: 'Enter your subscription name',
      ),
      keyboardType: TextInputType.text,
      validator: _validateSubscriptionName,
    );
  }
}

///
///
///
///
///

class SubscriptionPriceInput extends StatelessWidget {
  final TextEditingController controller;

  const SubscriptionPriceInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String? _validateSubscriptionPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a subscription price';
    }

    // Check if the value is a valid price in paisa
    final RegExp regex = RegExp(r'^\d+$');
    if (!regex.hasMatch(value)) {
      return 'Subscription price must be a valid number in paisa';
    }

    // Convert the value to an integer
    final int priceInPaisa = int.parse(value);

    // Check if the subscription price is within a valid range (e.g., between 100 and 100000 paisa)
    if (priceInPaisa < 0) {
      return 'Subscription price cannot be negative';
    }

    // You can add more specific validation criteria here if needed.

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Subscription Price',
        hintText: 'Enter your subscription price in paisa',
      ),
      keyboardType: TextInputType.number,
      validator: _validateSubscriptionPrice,
    );
  }
}

///
///
///
///
///

class SubscriptionDescriptionInput extends StatelessWidget {
  final TextEditingController controller;

  const SubscriptionDescriptionInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String? _validateSubscriptionDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a subscription description';
    }

    // Additional validation criteria can be added here if needed.

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Subscription Description',
        hintText: 'Enter your subscription description',
      ),
      keyboardType: TextInputType.text,
      maxLines: null, // Allows multi-line input
      validator: _validateSubscriptionDescription,
    );
  }
}

///
///
///
///
///

class SubscriptionSettingsForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final VoidCallback onSave;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SubscriptionSettingsForm({
    required this.nameController,
    required this.priceController,
    required this.descriptionController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SubscriptionNameInput(controller: nameController),
          const SizedBox(height: 10),
          SubscriptionPriceInput(controller: priceController),
          const SizedBox(height: 10),
          SubscriptionDescriptionInput(controller: descriptionController),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              // Validate individual fields as needed
              if (formKey.currentState!.validate()) {
                // Handle form submission
                onSave();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}
