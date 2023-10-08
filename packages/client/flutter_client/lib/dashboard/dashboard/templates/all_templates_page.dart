import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/datasource_dashboard.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../users/user_profile_page.dart';

@RoutePage()
class AllTemplatesPage extends StatefulWidget {
  const AllTemplatesPage({super.key});

  @override
  State<AllTemplatesPage> createState() => _AllTemplatesPageState();
}

class _AllTemplatesPageState extends State<AllTemplatesPage> {
  final AllTemplatesPageLogic allTemplatesPageLogic = AllTemplatesPageLogic();

  @override
  void initState() {
    super.initState();
    allTemplatesPageLogic.getMarketplaceTemplates(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: allTemplatesPageLogic.isLoading
            ? const Center(
                child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()),
              )
            : Center(
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
                      const SizedBox(height: 50),
                      // Text heading "Marketplace Templates"
                      const Text('Marketplace Templates', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 35),
                      // add new template , we need form for adding new template
                      // template name input
                      NewTemplateForm(onSubmit: (name, price) => {allTemplatesPageLogic.addTemplate(name, int.parse(price.toString()), setState)}),
                      const SizedBox(height: 50),
                      // text heading "All Templates"
                      const Text('All Templates', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 35),
                      // list of all templates
                      allTemplatesPageLogic.templates!.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: allTemplatesPageLogic.templates?.length,
                              itemBuilder: (context, index) => TemplateCard(
                                    template: allTemplatesPageLogic.templates![index],
                                  ))
                          : const NoResultFound(
                              icon: Icons.warning_amber_rounded,
                              heading: 'No Templates',
                              description: 'Template marketplace is empty now!',
                            )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class NewTemplateForm extends StatefulWidget {
  final Function(String name, double price) onSubmit;

  const NewTemplateForm({super.key, required this.onSubmit});

  @override
  _NewTemplateFormState createState() => _NewTemplateFormState();
}

class _NewTemplateFormState extends State<NewTemplateForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Price', hintText: 'Enter price in paisa'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              final double? parsedValue = double.tryParse(value);
              if (parsedValue == null) {
                return 'Invalid price format';
              }
              return null;
            },
            onSaved: (value) {
              _price = double.parse(value!);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(_name, _price);
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text('Add Template'),
          ),
        ],
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  final MarketplaceTemplate template;

  const TemplateCard({
    Key? key,
    required this.template,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushRoute(AdminUpdateTemplatePage(templateId: template.id.toString())),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            // Image
            Container(
              height: 250, // Adjust the image height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(template.previewImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Title
            Text(
              template.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            // Price
            Text(
              NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(template.price / 100),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Adjust the color as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllTemplatesPageLogic {
  bool isLoading = true;
  List<MarketplaceTemplate>? templates = [];

  // name controller
  final TextEditingController nameController = TextEditingController();
  // price controller
  final TextEditingController priceController = TextEditingController();

  Future<List<MarketplaceTemplate>?> getMarketplaceTemplates(void Function(void Function()) setState) async {
    setState(() => isLoading = true);
    templates = await DashboardDataService().getMarketplaceTemplates();
    setState(() => isLoading = false);
    return null;
  }

  // Add new template
  Future<void> addTemplate(String name, int price, void Function(void Function()) setState) async {
    await DashboardDataService().addTemplate(name, price);
    await getMarketplaceTemplates(setState);
    Fluttertoast.showToast(msg: "Template added", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
  }

  // update template
  Future<void> updateTemplate(BuildContext context, int id, void Function(void Function()) setState) async {
    var name = nameController.text;
    var price = int.parse(priceController.text);

    await DashboardDataService().updateMarketplaceTemplate(id, name, price);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Center(
          child: Text(
            'Template updated successfully!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Fetch single marketplace template
  Future<MarketplaceTemplate?> getSingleTemplate(int id, void Function(void Function()) setState) async {
    setState(() => isLoading = true);
    var data = await DashboardDataService().getSingleMarketplaceTemplate(id);
    nameController.text = data!.name;
    priceController.text = data.price.toString();
    setState(() => isLoading = false);
  }
}
