import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/dashboard/dashboard/dashboard-mobile.dart';
import 'package:flutter_client/client/pages/dashboard/market-place/market-place.dart';

class MarketPlaceMobile extends StatefulWidget {
  const MarketPlaceMobile({super.key});

  @override
  State<MarketPlaceMobile> createState() => _MarketPlaceMobileState();
}

class _MarketPlaceMobileState extends State<MarketPlaceMobile> {
  late final MarketPlaceLogic logic;

  _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    logic = MarketPlaceLogic(setStateCallback: _updateState);
    logic.fetchTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Add your action here
            context.popRoute(const MarketPlacePage());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Market Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: MarketPlacePageLayout(
            filterOption: logic.filterOption,
            onFilterOptionChanged: logic.setFilterOption,
            templates: logic.allTemplates,
            width: double.infinity,
            height: 400,
            canShowBackButton: false,
          ),
        ),
      ),
    );
  }
}
