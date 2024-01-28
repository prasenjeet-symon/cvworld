// ignore: file_names
import 'dart:async';

import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/view-resume/view-resume-desktop.dart';
import 'package:cvworld/client/pages/dashboard/view-resume/view-resume-mobile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewResume extends StatefulWidget {
  final int resumeID;

  const ViewResume({super.key, required this.resumeID});

  @override
  State<ViewResume> createState() => _ViewResumeState();
}

class _ViewResumeState extends State<ViewResume> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return ViewResumeMobile(resumeID: widget.resumeID);
      } else {
        return ViewResumeDesktop(resumeID: widget.resumeID);
      }
    });
  }
}

///
///
///
///
///
///

///
///
///
///
class ViewResumeButton extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const ViewResumeButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8.0),
          Text(buttonText, style: TextStyle(color: iconColor, fontSize: 16.0)),
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
class ResumeViewerLogic {
  late GeneratedResume? resume;
  bool isLoading = true;
  bool canDownload = false;
  Timer? timer;
  int buyTemplateCallbackCount = 0;

  final Function setStateCallback;

  ResumeViewerLogic({required this.setStateCallback});

  dispose() {
    timer?.cancel();
  }

  // Initialize the logic with the given resume ID
  Future<void> init(int resumeID) async {
    await fetchSingleResume(resumeID);
    final isSubscriber = await checkSubscriber();

    if (isSubscriber) {
      canDownload = true;
      isLoading = false;
      setStateCallback();
    } else {
      canDownload = await checkIsBought(resume!);
      isLoading = false;
      setStateCallback();
    }
  }

  // Fetch a single resume with the given resume ID
  Future<void> fetchSingleResume(int resumeID) async {
    try {
      var resumeFetched = await DatabaseService().fetchSingleResume(resumeID);
      resume = resumeFetched;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Check if the template is bought for the given resume
  Future<bool> checkIsBought(GeneratedResume resume) async {
    var isBought = await DatabaseService().isTemplateBought(resume.templateName);
    if (isBought != null) {
      return isBought.isBought;
    } else {
      return false;
    }
  }

  // Check if the user is a subscriber
  Future<bool> checkSubscriber() async {
    var user = await DatabaseService().fetchUser();
    return user?.subscription?.isActive ?? false;
  }

  // Buy the template for the given resume
  Future<void> buyTemplate(String templateName, Function callback) async {
    timer?.cancel();
    buyTemplateCallbackCount = 0;

    var url = await DatabaseService().buyTemplate(templateName);

    timer = Timer.periodic(const Duration(seconds: Constants.refreshSeconds), (timer) async {
      canDownload = await checkIsBought(resume!);
      setStateCallback();
      // If bought then show thanks popup
      if (canDownload && buyTemplateCallbackCount == 0) {
        buyTemplateCallbackCount = 1;
        timer.cancel();
        callback();
      }
    });

    TimerHolder().addTimer(timer);
    openLinkInBrowser(url.toString());
  }
}

///
///
///
///
///
///
class ResumeViewer extends StatefulWidget {
  final int resumeID;
  const ResumeViewer({super.key, required this.resumeID});

  @override
  State<ResumeViewer> createState() => _ResumeViewerState();
}

class _ResumeViewerState extends State<ResumeViewer> {
  late ResumeViewerLogic _logic;

  @override
  void initState() {
    super.initState();

    _logic = ResumeViewerLogic(setStateCallback: () {
      if (mounted) {
        setState(() {});
      }
    });

    _logic.dispose();
    _logic.init(widget.resumeID);
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  Future<void> _showGratitudePopup(BuildContext context, Function callback) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Thank You for Buying Our Template!',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'We appreciate your support.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  callback();
                  Navigator.of(context).pop();
                },
                child: const Text('Download Resume'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = _logic.isLoading;
    bool canDownload = _logic.canDownload;
    bool isMobile = MediaQuery.of(context).size.width < Constants.breakPoint;
    double width = isMobile ? MediaQuery.of(context).size.width * 0.85 : MediaQuery.of(context).size.width * 0.5;

    if (isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()));
    }

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMobile)
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: BackButtonApp(onPressed: () {
                      _logic.dispose();
                      Navigator.pop(context);
                    }),
                  ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 50),
                  child: Image.network(
                    _logic.resume!.resumeLink.imageUrl,
                    fit: BoxFit.fitWidth,
                    width: width,
                  ),
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Container(
                      width: isMobile ? width / 2 - 20 : 100,
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: ViewResumeButton(
                        onPressed: () {
                          _logic.dispose();
                          context.pushNamed(RouteNames.cvMaker, pathParameters: {"resumeID": widget.resumeID.toString(), "templateName": "Edit"});
                        },
                        buttonText: 'Edit',
                        backgroundColor: Colors.white,
                        iconColor: Colors.blue,
                        icon: Icons.edit,
                      ),
                    ),
                    SizedBox(
                      width: isMobile ? width / 2 : 200,
                      child: canDownload
                          ? ViewResumeButton(
                              onPressed: () {
                                _logic.dispose();
                                if (kIsWeb) {
                                  downloadFile(_logic.resume!.resumeLink.pdfUrl, _logic.resume!.resumeLink.pdfUrl);
                                } else {
                                  DatabaseService().downloadAndSavePdf(_logic.resume!.resumeLink.pdfUrl, context);
                                }
                              },
                              buttonText: 'Download',
                              backgroundColor: Colors.blue,
                              iconColor: Colors.white,
                              icon: Icons.download,
                            )
                          : ViewResumeButton(
                              onPressed: () {
                                _logic.buyTemplate(_logic.resume!.templateName, () {
                                  _showGratitudePopup(context, () {
                                    if (kIsWeb) {
                                      downloadFile(_logic.resume!.resumeLink.pdfUrl, _logic.resume!.resumeLink.pdfUrl);
                                    } else {
                                      DatabaseService().downloadAndSavePdf(_logic.resume!.resumeLink.pdfUrl, context);
                                    }
                                  });
                                });
                              },
                              buttonText: 'Buy Now',
                              backgroundColor: Colors.blue,
                              iconColor: Colors.white,
                              icon: Icons.attach_money_outlined,
                            ),
                    )
                  ],
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox())
        ],
      ),
    );
  }
}
