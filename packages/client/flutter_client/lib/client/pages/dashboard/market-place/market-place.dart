import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place-desktop.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place-mobile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.gr.dart';
import 'package:intl/intl.dart';

String formatAsIndianRupee(double amount) {
  final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  return format.format(amount);
}

@RoutePage()
class MarketPlacePage extends StatelessWidget {
  const MarketPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > Constants.breakPoint) {
        return const MarketPlaceDesktop();
      } else {
        return const MarketPlaceMobile();
      }
    });
  }
}

///
///
///
///
///
///
class MarketPlacePageLayout extends StatelessWidget {
  final FilterOption filterOption;
  final Function(int) onFilterOptionChanged;
  final List<TemplateMarketPlace>? templates;
  final double width;
  final double height;
  final bool canShowBackButton;

  const MarketPlacePageLayout({super.key, required this.filterOption, required this.onFilterOptionChanged, this.templates, required this.width, required this.height, required this.canShowBackButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        SizedBox(
          width: canShowBackButton ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(
                filterOption: filterOption,
                onFilterOptionChanged: onFilterOptionChanged,
                canShowBackButton: canShowBackButton,
              ),
              if (canShowBackButton) const HeaderTitleSection(),
              const SizedBox(height: 20),
              MarketPlaceTemplates(
                filterOption: filterOption,
                height: height,
                width: width,
                templates: templates,
              )
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

///
///
///
///
///
///
class HeaderSection extends StatelessWidget {
  final FilterOption filterOption;
  final Function(int) onFilterOptionChanged;
  final bool canShowBackButton;

  const HeaderSection({super.key, required this.filterOption, required this.onFilterOptionChanged, required this.canShowBackButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Row(
        children: [
          if (canShowBackButton)
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
                    onFilterOptionChanged(index);
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
            ),
          )
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
///
class HeaderTitleSection extends StatelessWidget {
  const HeaderTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

///
///
///
///
///
///
///
class MarketPlaceTemplates extends StatelessWidget {
  final List<TemplateMarketPlace>? templates;
  final FilterOption filterOption;
  final double width;
  final double height;

  const MarketPlaceTemplates({Key? key, this.templates, required this.filterOption, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TemplateMarketPlace> filteredTemplates;
    if (filterOption == FilterOption.Free) {
      filteredTemplates = templates!.where((template) => template.isFree == true).toList();
    } else if (filterOption == FilterOption.Premium) {
      filteredTemplates = templates!.where((template) => template.isFree == false).toList();
    } else {
      filteredTemplates = templates!;
    }

    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 20,
      runSpacing: 20,
      children: [
        ...filteredTemplates.map(
          (template) => MarketPlaceTemplateItem(
            templateName: template.name,
            templateDisplayName: template.displayName,
            imageUrl: template.previewImgUrl,
            price: template.price,
            isBought: template.isBought,
            isPremium: !template.isFree,
            width: width,
            height: height,
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
///
enum FilterOption {
  All,
  Free,
  Premium,
}

///
///
///
///
///
///
///
class IndianRupeeWidget extends StatelessWidget {
  final double amountInPaisa;

  const IndianRupeeWidget({Key? key, required this.amountInPaisa}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fmf = formatAsIndianRupee(amountInPaisa / 100);

    return Text(
      fmf,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
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
///
class MarketPlaceLogic {
  FilterOption filterOption = FilterOption.All;
  List<TemplateMarketPlace> allTemplates = [];
  List<TemplateMarketPlace> freeTemplates = [];
  List<TemplateMarketPlace> premiumTemplates = [];
  Function setStateCallback; // Accepts setState function
  bool isLoading = false; // Add isLoading property

  MarketPlaceLogic({required this.setStateCallback});

  // Fetch all the templates
  Future<void> fetchTemplates() async {
    isLoading = true;
    setStateCallback();

    allTemplates = (await DatabaseService().getMarketplaceTemplates()) ?? [];
    freeTemplates = allTemplates.where((element) => element.isFree == true).toList();
    premiumTemplates = allTemplates.where((element) => element.isFree == false).toList();

    isLoading = false;
    setStateCallback();
  }

  // Set the filter option
  void setFilterOption(int index) {
    switch (index) {
      case 0:
        filterOption = FilterOption.All;
        break;
      case 1:
        filterOption = FilterOption.Free;
        break;
      case 2:
        filterOption = FilterOption.Premium;
        break;
    }

    // Call setStateCallback to trigger UI update
    setStateCallback();
  }
}

///
///
///
///
///
///
class MarketPlaceTemplateItem extends StatelessWidget {
  final String imageUrl;
  final double price;
  final bool isPremium;
  final bool isBought;
  final String templateName;
  final String templateDisplayName;
  final double width;
  final double height;

  const MarketPlaceTemplateItem({
    Key? key,
    required this.imageUrl,
    required this.price,
    this.isPremium = false,
    this.isBought = false,
    required this.templateName,
    required this.templateDisplayName,
    required this.width,
    required this.height,
  }) : super(key: key);

  void createNewCV(BuildContext context) {
    context.router.push(CvMakerRoute(resumeID: 0, templateName: templateName));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        createNewCV(context);
      },
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
              Container(
                width: width,
                padding: const EdgeInsets.all(5), // Adjust padding as needed
                color: Colors.blue, // Set the background color
                child: Text(
                  templateDisplayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white, // Set the text color
                  ),
                ),
              ),
              TemplateImage(imageUrl: imageUrl, width: width, height: height),
              PriceAndIcons(
                price: price,
                isPremium: isPremium,
                isBought: isBought,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemplateImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const TemplateImage({Key? key, required this.imageUrl, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Image.network(imageUrl, fit: BoxFit.cover, width: width, height: height),
    );
  }
}

class PriceAndIcons extends StatelessWidget {
  final double price;
  final bool isPremium;
  final bool isBought;

  const PriceAndIcons({Key? key, required this.price, this.isPremium = false, this.isBought = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: IndianRupeeWidget(amountInPaisa: price),
          ),
          if (isBought) const Icon(Icons.check, color: Colors.green),
          if (isPremium) const Icon(Icons.star, color: Colors.orange),
        ],
      ),
    );
  }
}
