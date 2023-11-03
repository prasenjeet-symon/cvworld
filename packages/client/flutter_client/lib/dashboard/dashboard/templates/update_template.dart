import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/dashboard/templates/all_templates_page.dart';

@RoutePage()
class AdminUpdateTemplatePage extends StatefulWidget {
  final String templateId;

  const AdminUpdateTemplatePage({super.key, @PathParam() required this.templateId});

  @override
  State<AdminUpdateTemplatePage> createState() => _AdminUpdateTemplatePageState();
}

class _AdminUpdateTemplatePageState extends State<AdminUpdateTemplatePage> {
  final AllTemplatesPageLogic updateTemplatePageLogic = AllTemplatesPageLogic();

  @override
  void initState() {
    super.initState();
    updateTemplatePageLogic.getSingleTemplate(int.parse(widget.templateId), setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            width: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back button
                BackButtonApp(onPressed: () {
                  context.popRoute(const AllTemplatesPage());
                }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    // Text heading "Update Template"
                    const Text('Update Template', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 35),
                    UpdateTemplateForm(
                        nameController: updateTemplatePageLogic.nameController,
                        priceController: updateTemplatePageLogic.priceController,
                        templateId: widget.templateId,
                        updateTemplate: (id) => updateTemplatePageLogic.updateTemplate(context, id, setState)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///
///
///
///
///
///

class PriceInput extends StatelessWidget {
  final TextEditingController controller;

  const PriceInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }

    // Check if the value is a valid integer.
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Price must be a valid integer in paisa';
    }

    // Convert the value to an integer.
    final int priceInPaisa = int.tryParse(value) ?? 0;

    // Check if the price is greater than or equal to 0.
    if (priceInPaisa < 0) {
      return 'Price cannot be negative';
    }

    // Additional validation criteria can be added here if needed.

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(),
        hintText: 'Enter price in paisa',
      ),
      keyboardType: TextInputType.number,
      validator: _validatePrice,
    );
  }
}

///
///
///
///
///

class NameInput extends StatelessWidget {
  final TextEditingController controller;

  const NameInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }

    // Check if the name contains only letters and spaces.
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    // Check if the name doesn't start or end with a space.
    if (value.trim() != value) {
      return 'Name cannot start or end with spaces';
    }

    // Check if the name doesn't have consecutive spaces.
    if (value.contains(RegExp(r'\s\s'))) {
      return 'Name cannot have consecutive spaces';
    }

    // Additional validation criteria can be added here if needed.

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
        hintText: 'Enter your template name',
      ),
      keyboardType: TextInputType.text,
      validator: _validateName,
    );
  }
}

///
///
///
///
///

class UpdateTemplateForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final Function(int) updateTemplate;
  final String templateId; // Add the templateId parameter

  const UpdateTemplateForm({
    Key? key,
    required this.nameController,
    required this.priceController,
    required this.updateTemplate,
    required this.templateId, // Include the templateId parameter
  }) : super(key: key);

  @override
  _UpdateTemplateFormState createState() => _UpdateTemplateFormState();
}

class _UpdateTemplateFormState extends State<UpdateTemplateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          NameInput(controller: widget.nameController),
          const SizedBox(height: 10),
          PriceInput(controller: widget.priceController),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.updateTemplate(int.parse(widget.templateId));
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
