// ignore: file_names
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';

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
    return SizedBox(
      width: double.infinity,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back button holder
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
                          '24/7 we will answer all your questions and help you ',
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
  Function messageSent = () {};

  ContactUsForm({super.key, required this.messageSent});

  @override
  State<ContactUsForm> createState() => _ContactUsFormState();
}

class _ContactUsFormState extends State<ContactUsForm> {
  final TextEditingController _nameFirstController = TextEditingController();
  final TextEditingController _nameLastController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // submit
  Future<void> _submit(BuildContext context) async {
    String nameFirst = _nameFirstController.text;
    String nameLast = _nameLastController.text;
    String email = _emailController.text;
    String message = _messageController.text;
    String phone = _phoneController.text;
    String name = nameFirst + ' ' + nameLast;

    if (nameFirst.isNotEmpty && nameLast.isNotEmpty && email.isNotEmpty && message.isNotEmpty && phone.isNotEmpty) {
      await DatabaseService().contactUs(name, email, message, phone);
      widget.messageSent();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Empty fields...')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Two side by side form input for first name and last name
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: Row(
              children: [
                // fist name input holder
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    child: TextFormField(
                      controller: _nameFirstController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                // last name input holder
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    child: TextFormField(
                      controller: _nameLastController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Email input holder single
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          // Phone input holder
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone',
                hintText: 'Enter your phone',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
            ),
          ),
          // Message input holder ( text area auto resize and with some height )
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Message',
                hintText: 'Enter your message',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
            ),
          ),
          // A Big full width button ( SEND )
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                  'Sending...',
                )));

                _submit(context);
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(60)),
              child: const Text('SEND', style: TextStyle(fontSize: 20)),
            ),
          ),
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
// Message sent successfully
class ContactUsMessageSent extends StatelessWidget {
  const ContactUsMessageSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
      padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
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
    // TODO: implement build
    throw UnimplementedError();
  }
}
