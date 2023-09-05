import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/dashboard/dashboard/templates/all_templates_page.dart';

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
                    // add new template , we need form for adding new template
                    // template name input
                    TextFormField(
                      controller: updateTemplatePageLogic.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    // template price input
                    TextFormField(
                      controller: updateTemplatePageLogic.priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 25),
                    // update template
                    ElevatedButton(
                      onPressed: () {
                        updateTemplatePageLogic.updateTemplate(
                          int.parse(widget.templateId),
                          setState,
                        );
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
                    )
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
