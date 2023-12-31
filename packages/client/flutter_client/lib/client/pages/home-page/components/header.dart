import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';

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
                    onPressed: () => {context.navigateNamedTo('/')},
                    child: const Text('Home', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: TextButton(
                    onPressed: () => {context.navigateNamedTo('/contact-us')},
                    child: const Text('Contact Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: TextButton(
                    onPressed: () => {},
                    child: const Text('About Us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                //   child: TextButton(
                //     onPressed: () => {pricingSectionCallback()},
                //     child: const Text('Pricing', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                //   ),
                // ),
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
            onPressed: () => {context.pushRoute(const SignInRoute())},
            child: const Text('Log In', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: ElevatedButton(
              onPressed: () => {context.pushRoute(const SignUpRoute())},
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: 40,
      height: 40,
      child: Image.network(
        'https://logos-download.com/wp-content/uploads/2016/06/General_Electric_logo_GE.png',
        fit: BoxFit.cover,
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
