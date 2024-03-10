import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContinueWithGoogle extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData icon;

  const ContinueWithGoogle({super.key, required this.onPressed, required this.buttonText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          padding: const EdgeInsets.all(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon),
            Container(margin: const EdgeInsets.fromLTRB(10, 0, 0, 0), child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}
