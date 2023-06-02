import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'expandable-card.dart';

@RoutePage()
class AddNameScreen extends StatelessWidget {
  const AddNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return const AddNameMobileScreen();
        } else {
          return ExpandableCard(
            title: 'He',
            children: Text('hello'),
            onDelete: () {},
          );
        }
      }),
    );
  }
}

class AddNameDesktopScreen extends StatefulWidget {
  const AddNameDesktopScreen({super.key});

  @override
  State<AddNameDesktopScreen> createState() => _AddNameDesktopScreenState();
}

class _AddNameDesktopScreenState extends State<AddNameDesktopScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          const Positioned(
            top: 10,
            left: 10,
            child: Text('Logo Here'),
          ),
          Positioned(
              bottom: 30,
              left: 1,
              width: 450,
              child: Image.asset(
                'add-name-image.png',
                fit: BoxFit.cover,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                width: 500,
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                      child: const Text(
                        'Add your name',
                        style: TextStyle(
                            fontSize: 45,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                        child: const Text(
                          "You made a great selection! Now let's add your name to it.",
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w500),
                        )),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Column(
                        children: [
                          TextField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                            ),
                          ),
                          TextField(
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Handle back button press
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Button press action
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .blue, // Transparent background// No shadow
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25, horizontal: 35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class AddNameMobileScreen extends StatelessWidget {
  const AddNameMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}
