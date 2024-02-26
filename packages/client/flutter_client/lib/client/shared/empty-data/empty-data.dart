import 'package:cvworld/client/utils.dart';
import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const EmptyData({super.key, required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 100, 0, 20),
      width: double.infinity,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width > Constants.breakPoint ? 700 : double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              Image.asset('assets/${image}', width: 180, height: 180, fit: BoxFit.cover),
              const SizedBox(height: 20),
              // Heading
              Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Description
              Text(description, style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
