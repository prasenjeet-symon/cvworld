// ignore: file_names
import 'dart:async';
import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/dashboard/view-resume/view-resume-mobile.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'view-resume-desktop.dart';

@RoutePage()
class ViewResume extends StatefulWidget {
  final int resumeID;

  const ViewResume({super.key, @PathParam() required this.resumeID});

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
  late Timer timer;

  final Function setStateCallback;

  ResumeViewerLogic({required this.setStateCallback});

  dispose() {
    if (timer.isDefinedAndNotNull) {
      timer.cancel();
    }
  }

  // Initialize the logic with the given resume ID
  Future<void> init(int resumeID) async {
    await fetchSingleResume(resumeID);
    final isSubscriber = await checkSubscriber();

    if (isSubscriber) {
      canDownload = true;
      setStateCallback();
    } else {
      canDownload = await checkIsBought(resume!);
      setStateCallback();
    }
  }

  // Fetch a single resume with the given resume ID
  Future<void> fetchSingleResume(int resumeID) async {
    isLoading = true;
    setStateCallback();

    try {
      var resumeFetched = await DatabaseService().fetchSingleResume(resumeID);
      resume = resumeFetched;
    } catch (e) {
      await Fluttertoast.showToast(
        msg: 'Something went wrong...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        textColor: Colors.white,
      );
    }

    isLoading = false;
    setStateCallback();
  }

  // Check if the template is bought for the given resume
  Future<bool> checkIsBought(GeneratedResume resume) async {
    var isBought = await DatabaseService().isTemplateBought(resume.templateName);
    if (isBought.isDefinedAndNotNull) {
      return isBought!.isBought;
    } else {
      return false;
    }
  }

  // Check if the user is a subscriber
  Future<bool> checkSubscriber() async {
    var user = await DatabaseService().fetchUser();
    if (user.isDefinedAndNotNull) {
      if (user!.subscription.isDefinedAndNotNull && user.subscription!.isActive) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // Buy the template for the given resume
  Future<void> buyTemplate(String templateName) async {
    var url = await DatabaseService().buyTemplate(templateName);
    if (url.isDefinedAndNotNull) {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        timer = timer;
        init(resume!.id);
      });

      openLinkInBrowser(url.toString());
    }
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

    _logic.init(widget.resumeID);
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
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
                      context.popRoute(ViewResume(resumeID: widget.resumeID));
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
                          // Add your download functionality here
                          context.pushRoute(CvMakerRoute(resumeID: widget.resumeID, templateName: 'Edit'));
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
                                downloadFile(_logic.resume!.resumeLink.pdfUrl, _logic.resume!.resumeLink.pdfUrl);
                              },
                              buttonText: 'Download',
                              backgroundColor: Colors.blue,
                              iconColor: Colors.white,
                              icon: Icons.download,
                            )
                          : ViewResumeButton(
                              onPressed: () {
                                _logic.buyTemplate(_logic.resume!.templateName);
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
