import 'dart:async';

import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/templates-page/templates-page.controller.dart';
import 'package:cvworld/client/pages/dashboard/templates-page/templates-page.dart';
import 'package:cvworld/client/shared/empty-data/empty-data.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/config.dart';
import 'package:flutter/material.dart';

class TemplatesPageMobile extends StatefulWidget {
  const TemplatesPageMobile({super.key});

  @override
  State<TemplatesPageMobile> createState() => _TemplatesPageMobileState();
}

class _TemplatesPageMobileState extends State<TemplatesPageMobile> {
  TemplatePageController controller = TemplatePageController();

  List<Template> templates = [];
  bool isLoading = true;
  StreamSubscription? _subscription;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _subscription = controller.getTemplates().listen((event) {
      if (mounted) {
        setState(() {
          templates = event.data;
          isLoading = event.status == ModelStoreStatus.ready ? false : true;
        });
      }
    });

    searchController.addListener(() {
      _search(searchController.text);
    });
  }

  // Search
  void _search(String query) {
    controller.search(query);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Templates'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        // Search
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                            width: 300,
                            child: TextField(controller: searchController, decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Search...')),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TemplatesPageList(templates: templates),
                    templates.isEmpty && !isLoading ? const EmptyData(title: 'No Templates', description: 'Oops! Looks like we have no templates', image: 'template.png') : Container(),
                  ],
                ),
              )
              // Put page footer if needed just below
            ],
          ),
        ),
      ),
    );
  }
}
