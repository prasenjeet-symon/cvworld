import 'package:cvworld/client/datasource/network.api.dart';
import 'package:cvworld/client/datasource/schema.dart';
import 'package:cvworld/client/pages/dashboard/market-place/market-place.dart';
import 'package:cvworld/client/pages/dashboard/templates-page/templates-page.controller.dart';
import 'package:cvworld/client/pages/dashboard/templates-page/templates-page.mobile.dart';
import 'package:cvworld/client/pages/dashboard/templates-page/templates-page.web.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        // Mobile
        return const TemplatesPageMobile();
      } else {
        // Desktop
        return const TemplatesPageWeb();
      }
    });
  }
}

///
///
///
/// Template item free
class TemplateItem extends StatefulWidget {
  final Template template;

  const TemplateItem({super.key, required this.template});

  @override
  State<TemplateItem> createState() => _TemplateItemState();
}

class _TemplateItemState extends State<TemplateItem> {
  TemplatePageController controller = TemplatePageController();

  // Open sample image in browser
  _openSample() {
    openLinkInBrowser(NetworkApi.publicResource(widget.template.previewImgUrl));
  }

  // Add to like
  void _addToLike() {
    controller.addToLike(widget.template);
  }

  // Remove from like
  void _removeFromLike() {
    controller.removeFromLike(widget.template);
  }

  // Add to default
  void _addToDefault() {
    controller.addToDefault(widget.template);
  }

  // Remove from default
  void _removeFromDefault() {
    controller.removeFromDefault(widget.template);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 245,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(image: NetworkImage(NetworkApi.publicResource(widget.template.previewImgUrl)), fit: BoxFit.cover),
                  ),
                ),
                formatAsIndianRupee(widget.template.price) != formatAsIndianRupee(0.00)
                    ? const Positioned(
                        top: 10,
                        right: 10,
                        child: Chip(backgroundColor: Colors.green, label: Text('Premium', style: TextStyle(color: Colors.white))),
                      )
                    : Container(),
              ],
            ),
            // Price bold
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Row(
                children: [
                  Text(formatAsIndianRupee(widget.template.price), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
                  const Expanded(child: SizedBox()),
                  widget.template.isMyFavourite
                      ? IconButton(
                          onPressed: () {
                            _removeFromLike();
                          },
                          icon: const Icon(Icons.favorite, color: Colors.red))
                      : IconButton(
                          onPressed: () {
                            _addToLike();
                          },
                          icon: const Icon(Icons.favorite_border, color: Colors.red)),
                  IconButton(
                    onPressed: () {
                      _openSample();
                    },
                    icon: const Icon(Icons.open_in_browser, color: Colors.blue),
                  ),
                  widget.template.isMyDefault
                      ? IconButton(
                          onPressed: () {
                            _removeFromDefault();
                          },
                          icon: const Icon(Icons.pin_drop, color: Colors.blue))
                      : IconButton(
                          onPressed: () {
                            _addToDefault();
                          },
                          icon: const Icon(Icons.pin_drop_outlined, color: Colors.blue)),
                ],
              ),
            ),
            // Name of template
            Text(widget.template.displayName, style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }
}

///
///
///
/// List all templates
class TemplatesPageList extends StatefulWidget {
  final List<Template> templates;

  const TemplatesPageList({super.key, required this.templates});

  @override
  State<TemplatesPageList> createState() => _TemplatesPageListState();
}

class _TemplatesPageListState extends State<TemplatesPageList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > Constants.breakPoint ? 3 : 1,
            shrinkWrap: true,
            children: [...widget.templates.map((e) => TemplateItem(key: ValueKey(e.name), template: e))],
          );
        },
      ),
    );
  }
}
