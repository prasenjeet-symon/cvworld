import 'package:flutter/material.dart';

class PriceSection extends StatefulWidget {
  const PriceSection({
    Key? key,
  }) : super(key: key);

  @override
  State<PriceSection> createState() => PriceSectionState();
}

class PriceSectionState extends State<PriceSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const PriceSectionMobile();
      } else {
        return const PriceSectionDesktop();
      }
    });
  }
}

class PriceSectionMobile extends StatelessWidget {
  const PriceSectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Mobile');
  }
}

class PriceSectionDesktop extends StatelessWidget {
  const PriceSectionDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFFF6EEE8),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Text(
              'Simple plans for everyone',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            child: SizedBox(),
          ),
          Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(15),
                width: 300,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'Free',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextSpan(
                                  text: '00.00',
                                  style: TextStyle(fontSize: 24, color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Container(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                              side: BorderSide(color: Colors.blue),
                              textStyle: TextStyle(color: Colors.blue),
                            ),
                            child: Text('Get Started'),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Easy to use online resume builder',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'ATS optimized resumes',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                padding: EdgeInsets.all(15),
                width: 300,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'Premium',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$',
                                  style: TextStyle(fontSize: 16),
                                ),
                                TextSpan(
                                  text: '99.00',
                                  style: TextStyle(fontSize: 24, color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button press
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            child: Text('Try Premium'),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Easy to use online resume builder',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'ATS optimized resumes',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 15,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      child: Text(
                                        'Trusted by verified resume writers',
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
