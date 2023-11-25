import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class HeaderSection extends StatelessWidget {
  Function pricingSectionCallback;

  HeaderSection({super.key, required this.pricingSectionCallback});

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;
    return isMobile ? const HeaderSectionMobile() : HeaderSectionDesktop(pricingSectionCallback: pricingSectionCallback);
  }
}

// ignore: must_be_immutable
class HeaderMenus extends StatelessWidget {
  Function pricingSectionCallback;

  HeaderMenus({super.key, required this.pricingSectionCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HeaderLogo(),
          Container(
            margin: const EdgeInsets.fromLTRB(60, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: TextButton(
                    onPressed: () => {context.pushNamed(RouteNames.contactUs)},
                    child: const Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: TextButton(
                    onPressed: () => {context.pushNamed(RouteNames.aboutUs)},
                    child: const Text('About Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => {context.pushNamed(RouteNames.signin)},
            child: const Text('Log In', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () => {context.pushNamed(RouteNames.signup)},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
              child: const Text('Sign Up', style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({super.key});

  // Define a function to handle the tap action
  void _handleLogoTap(BuildContext context) {
    // Implement the action you want when the logo is clicked
    // For example, you can navigate to a different screen.
    context.pushNamed(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleLogoTap(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        width: 45,
        height: 45,
        color: Colors.white,
        child: Image.asset('assets/logo.png', fit: BoxFit.cover),
      ),
    );
  }
}

// ignore: must_be_immutable
class HeaderSectionDesktop extends StatelessWidget {
  Function pricingSectionCallback;

  HeaderSectionDesktop({super.key, required this.pricingSectionCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: HeaderMenus(pricingSectionCallback: pricingSectionCallback)), const HeaderActions()],
      ),
    );
  }
}

class HeaderSectionMobile extends StatelessWidget {
  const HeaderSectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.center, children: [HeaderLogo(), Expanded(child: SizedBox()), HeaderActions()]),
    );
  }
}
