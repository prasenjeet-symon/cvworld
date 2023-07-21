import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:money_formatter/money_formatter.dart';

@RoutePage()
class MarketPlacePage extends StatelessWidget {
  const MarketPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return const MarketPlacePageDesktop();
      } else {
        return const MarketPlacePageMobile();
      }
    });
  }
}

// For the desktop
class MarketPlacePageDesktop extends StatefulWidget {
  const MarketPlacePageDesktop({super.key});

  @override
  State<MarketPlacePageDesktop> createState() => _MarketPlacePageDesktopState();
}

class _MarketPlacePageDesktopState extends State<MarketPlacePageDesktop> {
  FilterOption filterOption = FilterOption.All;
  List<TemplateMarketPlace>? allTemplates;
  List<TemplateMarketPlace>? freeTemplates;
  List<TemplateMarketPlace>? premiumTemplates;

  // fetch all the templates
  Future<void> fetchTemplates() async {
    allTemplates = await DatabaseService().getMarketplaceTemplates();
    freeTemplates = allTemplates!.where((element) => element.isFree == true).toList();
    premiumTemplates = allTemplates!.where((element) => element.isFree == false).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchTemplates().then((value) => {setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          SizedBox(
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Row(
                    children: [
                      BackButtonApp(
                        onPressed: () {
                          context.popRoute(const MarketPlacePage());
                        },
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ToggleButtons(
                            isSelected: [
                              filterOption == FilterOption.All,
                              filterOption == FilterOption.Free,
                              filterOption == FilterOption.Premium,
                            ],
                            onPressed: (index) {
                              setState(() {
                                filterOption = FilterOption.values[index];
                              });
                            },
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const Text('All'),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const Text('Free'),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const Text('Premium'),
                              ),
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                // Header title and description section
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: const Text(
                          'Market Place',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: const Text(
                          'Choose your favorite template and make your CV.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Holds all the templates
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 150),
                  child: filterOption == FilterOption.All
                      ? MarketPlaceAllTemplate(
                          allTemplates: allTemplates ?? [],
                        )
                      : filterOption == FilterOption.Free
                          ? MarketPlaceFreeTemplate(freeTemplates: freeTemplates ?? [])
                          : MarketPlacePremiumTemplate(premiumTemplates: premiumTemplates ?? []),
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    ));
  }
}

///
///
///
///
///
///
/// For the free templates
class MarketPlaceFreeTemplate extends StatelessWidget {
  final List<TemplateMarketPlace>? freeTemplates;

  const MarketPlaceFreeTemplate({super.key, this.freeTemplates});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 20, // Spacing between the children horizontally
      runSpacing: 20,
      children: [
        ...freeTemplates!.map((e) {
          return MarketPlaceTemplateItem(
            templateName: e.name,
            imageUrl: e.previewImgUrl,
            label: e.price.toString(),
            isBought: e.isBought,
            isPremium: false,
          );
        }).toList()
      ],
    );
  }
}

///
///
///
///
///
/// For the premium templates
class MarketPlacePremiumTemplate extends StatelessWidget {
  final List<TemplateMarketPlace>? premiumTemplates;

  const MarketPlacePremiumTemplate({super.key, this.premiumTemplates});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 20, // Spacing between the children horizontally
      runSpacing: 20,
      children: [
        ...premiumTemplates!
            .map((e) => MarketPlaceTemplateItem(
                  templateName: e.name,
                  imageUrl: e.previewImgUrl,
                  label: e.price.toString(),
                  isBought: e.isBought,
                  isPremium: true,
                ))
            .toList()
      ],
    );
  }
}

///
///
///
///
/// For the all templates
class MarketPlaceAllTemplate extends StatelessWidget {
  final List<TemplateMarketPlace>? allTemplates;

  const MarketPlaceAllTemplate({super.key, this.allTemplates});

  @override
  Widget build(BuildContext context) {
    // Return flex with two children
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 20, // Spacing between the children horizontally
      runSpacing: 20,
      children: [
        ...(allTemplates!
            .map((e) => MarketPlaceTemplateItem(
                  templateName: e.name,
                  imageUrl: e.previewImgUrl,
                  label: e.price.toString(),
                  isBought: e.isBought,
                  isPremium: !e.isFree,
                ))
            .toList()),
      ],
    );
  }
}

///
///
///
///
///For the template item
class MarketPlaceTemplateItem extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool isPremium;
  final bool isBought;
  final String templateName;

  // nav to the cv maker new
  void createNewCV(BuildContext context) {
    context.router.push(CvMakerRoute(resumeID: 0, templateName: templateName));
  }

  const MarketPlaceTemplateItem({super.key, required this.imageUrl, required this.label, this.isPremium = false, this.isBought = false, required this.templateName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        createNewCV(context);
      },
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: 480,
          height: 600,
          child: Column(
            children: [
              Expanded(
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(children: [
                  Expanded(
                    // price in indian rupees
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: IndianRupeeWidget(amountInPaisa: int.parse(label)),
                    ),
                  ),
                  isBought ? const Icon(Icons.check, color: Colors.green) : const SizedBox(),
                  isPremium ? const Icon(Icons.star, color: Colors.orange) : const SizedBox()
                ]),
              )
            ],
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
// For the mobile version
class MarketPlacePageMobile extends StatelessWidget {
  const MarketPlacePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

///
///
///
///
///
enum FilterOption {
  // ignore: constant_identifier_names
  All,
  // ignore: constant_identifier_names
  Free,
  // ignore: constant_identifier_names
  Premium,
}

class IndianRupeeWidget extends StatelessWidget {
  final int amountInPaisa;

  const IndianRupeeWidget({super.key, required this.amountInPaisa});

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: amountInPaisa.toDouble() / 100,
      settings: MoneyFormatterSettings(symbol: '₹'),
    );

    return Text(
      fmf.output.compactSymbolOnLeft,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
