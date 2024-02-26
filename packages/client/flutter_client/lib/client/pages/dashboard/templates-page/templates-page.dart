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
class TemplateItem extends StatelessWidget {
  const TemplateItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: const DecorationImage(image: NetworkImage('https://picsum.photos/200'), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  child: Chip(backgroundColor: Colors.green, label: Text('Premium', style: TextStyle(color: Colors.white))),
                  top: 10,
                  right: 10,
                ),
                // Mark as favorite
                Positioned(
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, color: Colors.white)),
                  top: 10,
                  left: 10,
                ),
                // Open to browser
                Positioned(
                  child: IconButton(onPressed: () {}, icon: const Icon(Icons.open_in_browser, color: Colors.white)),
                  top: 10,
                  left: 50,
                )
              ],
            ),
            // Price bold
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text('₹ 50.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
            ),
            // Name of template
            Text('Template One', style: TextStyle(fontSize: 15, color: Colors.grey.shade700), textAlign: TextAlign.center),
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
class TemplatesPageList extends StatelessWidget {
  const TemplatesPageList({super.key});

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
            children: [
              TemplateItem(),
              TemplateItem(),
              TemplateItem(),
              TemplateItem(),
              TemplateItem(),
              TemplateItem(),
            ],
          );
        },
      ),
    );
  }
}
