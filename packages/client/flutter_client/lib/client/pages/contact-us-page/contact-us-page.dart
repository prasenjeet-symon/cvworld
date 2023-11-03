// ignore: file_names
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/signin-page/components/signin_form_mobile.dart';

import '../../utils.dart';
import '../home-page/components/footer.dart';

@RoutePage()
class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      return const ContactUsPageMobile();
    } else {
      return const ContactUsPageDesktop();
    }
  }
}

///
///
///
///
///
///
// Desktop Screen
class ContactUsPageDesktop extends StatefulWidget {
  const ContactUsPageDesktop({super.key});

  @override
  State<ContactUsPageDesktop> createState() => _ContactUsPageDesktopState();
}

class _ContactUsPageDesktopState extends State<ContactUsPageDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: SingleChildScrollView(child: Column(children: [ContactUsPageDesktopBody(), FooterSection()])));
  }
}

// Desktop Screen Body
class ContactUsPageDesktopBody extends StatefulWidget {
  const ContactUsPageDesktopBody({super.key});

  @override
  State<ContactUsPageDesktopBody> createState() => _ContactUsPageDesktopBodyState();
}

class _ContactUsPageDesktopBodyState extends State<ContactUsPageDesktopBody> {
  bool isMessageSent = false;
  messageSent() {
    setState(() {
      isMessageSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;

    return SizedBox(
      width: double.infinity,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!isMobile)
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: 700,
              color: Colors.blue,
              child: Image.asset(
                'assets/contact_us.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),
        Expanded(
          flex: 2,
          child: isMessageSent
              ? const ContactUsMessageSent()
              : Container(
                  width: double.infinity,
                  margin: isMobile ? const EdgeInsets.fromLTRB(30, 0, 30, 0) : const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back button holder
                      if (!isMobile)
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width: double.infinity,
                          child: Row(children: [
                            BackButtonApp(onPressed: () {
                              context.navigateBack();
                            }),
                            const Expanded(child: SizedBox()),
                          ]),
                        ),
                      // Contact us title ( GET IN TOUCH ) where touch is bold only
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: double.infinity,
                        child: const Text(
                          'GET IN TOUCH',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      // Contact us subtitle ( 24/7 we will answer all your questions and help you )
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        child: Text(
                          ' We will answer all your questions and help you 24/7! ',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Form holder for contact us
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        child: ContactUsForm(messageSent: messageSent),
                      )
                    ],
                  ),
                ),
        )
      ]),
    );
  }
}

///
///
///
///
///
// Contact us form
class ContactUsForm extends StatefulWidget {
  final Function messageSent;

  ContactUsForm({required this.messageSent});

  @override
  _ContactUsFormState createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFirstController = TextEditingController();
  final TextEditingController _nameLastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // submit
  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String nameFirst = _nameFirstController.text;
      String nameLast = _nameLastController.text;
      String email = _emailController.text;
      String message = _messageController.text;
      String phone = _phoneController.text;
      String name = '$nameFirst $nameLast';

      await DatabaseService().contactUs(name, email, message, phone);
      widget.messageSent();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Center(
            child: Text(
              'Please fix the errors in the form.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: NameInput(
                    controller: _nameFirstController,
                    labelText: 'First Name',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: NameInput(
                    controller: _nameLastController,
                    labelText: 'Last Name',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            EmailInput(emailController: _emailController),
            const SizedBox(height: 20),
            PhoneNumberInput(controller: _phoneController),
            const SizedBox(height: 20),
            MessageInput(controller: _messageController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _submit(context);
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(60)),
                child: const Text('SEND', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
///
///

class NameInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  NameInput({
    required this.controller,
    required this.labelText,
  });

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '$labelText is required';
    }

    // You can add more specific validation criteria here.
    // For example, ensuring that the name contains only letters and spaces:
    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value)) {
      return '$labelText can only contain letters and spaces';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hintText = 'Enter your $labelText';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: _validateName, // Use the internal validator function
      keyboardType: TextInputType.text,
    );
  }
}

///
///
///
///
///
///
class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;

  PhoneNumberInput({required this.controller});

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Validate the phone number format using a regular expression.
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Invalid phone number. Please enter 10 digits.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Phone',
        hintText: 'Enter your phone number',
        border: OutlineInputBorder(),
      ),
      validator: _validatePhoneNumber, // Use the internal validator function
      keyboardType: TextInputType.phone,
    );
  }
}

///
///
///
///
class MessageInput extends StatelessWidget {
  final TextEditingController controller;

  MessageInput({
    required this.controller,
  });

  String? _validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Message is required';
    }

    // Check for code-like patterns using regular expressions.
    if (RegExp(r'<[A-Za-z\/][^>]*>').hasMatch(value)) {
      return 'Code input is not allowed';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Message',
        hintText: 'Enter your message',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: _validateMessage, // Use the internal validator function
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: 5,
    );
  }
}

///
///
///
///
///
// Message sent successfully
class ContactUsMessageSent extends StatelessWidget {
  const ContactUsMessageSent({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
      padding: isMobile ? const EdgeInsets.fromLTRB(20, 0, 20, 0) : const EdgeInsets.fromLTRB(100, 0, 100, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG image holder
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: 250,
                height: 250,
                child: Image.asset('assets/msg_sent.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              )
            ],
          ),
          // Congratulations
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: const Text(
              'Congratulations!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Message sent successfully
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: Text(
              'Your message has been sent successfully.',
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // A Big full width button ( BACK TO HOME )
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: 400,
            child: ElevatedButton(
              onPressed: () {
                context.navigateBack();
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
              child: const Text('BACK TO HOME', style: TextStyle(fontSize: 20)),
            ),
          )
        ],
      ),
    );
  }
}

///
///
///
///
///
///
// For the mobile screen
class ContactUsPageMobile extends StatefulWidget {
  const ContactUsPageMobile({super.key});

  @override
  State<ContactUsPageMobile> createState() => _ContactUsPageMobileState();
}

class _ContactUsPageMobileState extends State<ContactUsPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('Contact Us'),
            leading: IconButton(
              onPressed: () {
                // ignore: deprecated_member_use
                context.navigateBack();
              },
              icon: const Icon(Icons.arrow_back),
            )),
        body: const SingleChildScrollView(child: Column(children: [ContactUsPageDesktopBody()])));
  }
}
