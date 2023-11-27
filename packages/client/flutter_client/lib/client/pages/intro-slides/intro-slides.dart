import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intro_slider/intro_slider.dart';

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
          DatabaseService().setTutorialCompleted().then((value) {
            context.goNamed(RouteNames.dashboard);
          });
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
        description: "Effortlessly create a standout professional resume in minutes. Our intuitive platform offers templates to showcase your skills and experience, helping you secure your dream job with ease.",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_1.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
      const ContentConfig(
        title: "Choose a Template",
        description: "Choose from a diverse collection of professionally designed templates to elevate your resume. Find the perfect style to complement your achievements and make a lasting impression on potential employers.",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_2.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
      const ContentConfig(
        title: "Customize Resume",
        description: "Tailor your resume effortlessly by customizing content, colors, and styles to align with your unique preferences. Create a personalized and professional document that reflects your individuality and stands out.",
        styleDescription: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
        styleTitle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 35),
        pathImage: "assets/slide_3.png", // Replace with your image asset
        backgroundColor: Colors.white,
      ),
      const ContentConfig(
        title: "Export and Share",
        description: "Seamlessly export your customized resume as a PDF, ensuring a polished and professional presentation. Share your document confidently with potential employers, making a strong impression in your job search.",
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
