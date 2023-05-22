import 'package:flutter/material.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const SectionTwoMobile();
      } else {
        return const SectionTwoDesktop();
      }
    });
  }
}

class SectionTwoMobile extends StatelessWidget {
  const SectionTwoMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Mobie');
  }
}

class SectionTwoDesktop extends StatelessWidget {
  const SectionTwoDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  const Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lorem ipsum dolor sit.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                          'Lorem ipsum dolor sit amet consectetur adipisicing elit. Sit error maxime temporibus distinctio maiores ratione.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16)),
                    ],
                  )),
                  Expanded(
                      child: Image.network(
                    'https://cdni.iconscout.com/illustration/free/thumb/teamwork-2112512-1785594.png',
                    fit: BoxFit.cover,
                  )),
                ],
              )),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
