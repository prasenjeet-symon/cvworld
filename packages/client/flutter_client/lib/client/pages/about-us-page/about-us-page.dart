import 'package:auto_route/auto_route.dart';
import 'package:cvworld/client/pages/home-page/components/footer.dart';
import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return AboutUsPageMobile();
    } else {
      return const AboutUsPageDesktop();
    }
  }
}

class AboutUsPageDesktop extends StatelessWidget {
  const AboutUsPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [AboutUsPageDesktopBody(), const FooterSection()],
        ),
      ),
    );
  }
}

class AboutUsPageMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class AboutUsPageDesktopBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(16.0),
        margin: EdgeInsets.fromLTRB(0, 25, 0, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButtonApp(onPressed: () {
              context.navigateBack();
            }),
            const SizedBox(height: 32),
            const Text(
              'About CV World',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'At CV World, we believe that creating the perfect resume should be a seamless and empowering experience. Our user-friendly platform is designed to assist job seekers in crafting professional, eye-catching resumes effortlessly. With the mission to simplify the resume-building process, CV World offers a diverse array of customizable templates that cater to a wide range of industries and career levels.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Innovative Approach',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our innovative system allows users to input their details just once, and then generate multiple resumes with various designs and formats. Say goodbye to the tedious task of manually tailoring your resume for different job applications; with CV World, you can effortlessly adapt your resume to various roles, industries, and preferences.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cutting-Edge Technology',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Backed by cutting-edge technology, our platform is continuously updated to integrate the latest trends in resume design and content presentation. We understand that a well-crafted resume is crucial in making a lasting first impression, and that\'s why we are dedicated to providing you with the tools and resources necessary to stand out in today\'s competitive job market.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Join Us Today',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Join the thousands of satisfied users who have already streamlined their resume creation process with CV World. Let us help you showcase your skills and experiences in the best possible light, and take the first step toward your dream career today.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the CV World website
                // You can use the launch URL package or any navigation method of your choice
              },
              child: const Text('Visit us at www.cvworld.me'),
            ),
          ],
        ));
  }
}
