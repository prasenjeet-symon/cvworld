import 'package:flutter/material.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart';

class MarketPlaceDesktop extends StatefulWidget {
  const MarketPlaceDesktop({super.key});

  @override
  State<MarketPlaceDesktop> createState() => _MarketPlaceDesktopState();
}

class _MarketPlaceDesktopState extends State<MarketPlaceDesktop> {
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
      body: SingleChildScrollView(
        child: MarketPlacePageLayout(
          filterOption: logic.filterOption,
          onFilterOptionChanged: logic.setFilterOption,
          templates: logic.allTemplates,
          width: 300,
          height: 300,
          canShowBackButton: true,
        ),
      ),
    );
  }
}
