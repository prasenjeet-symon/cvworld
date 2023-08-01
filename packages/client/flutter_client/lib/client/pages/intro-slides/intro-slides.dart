import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:intro_slider/intro_slider.dart';

@RoutePage()
class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({super.key});

  @override
  State<IntroSliderPage> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSliderPage> {
  final IntroSlideLogic _introSlideLogic = IntroSlideLogic();

  @override
  void initState() {
    super.initState();
    _introSlideLogic.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroSlider(
        key: UniqueKey(),
        listContentConfig: _introSlideLogic.slides,
        onDonePress: () {
          DatabaseService().setTutorialCompleted().then((value) => {context.pushRoute(const Dashboard())});
        },
      ),
    );
  }
}

class IntroSlideLogic {
  List<ContentConfig> slides = [];

  List<ContentConfig> getSlides() {
    return [
      const ContentConfig(
        title: "Welcome",
        description: "Create a professional resume in minutes!",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_1.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
      const ContentConfig(
        title: "Choose a Template",
        description: "Select from a variety of beautifully designed templates.",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_2.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
      const ContentConfig(
        title: "Customize Resume",
        description: "Edit the content, colors, and styles to fit your needs.",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_3.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
      const ContentConfig(
        title: "Export and Share",
        description: "Export your resume as a PDF and share it with potential employers.",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_4.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
    ];
  }

  void init() {
    slides = getSlides();
  }
}
