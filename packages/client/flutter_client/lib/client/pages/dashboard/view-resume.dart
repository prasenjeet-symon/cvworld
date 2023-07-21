// ignore: file_names
import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/pages/dashboard/header.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      if (constraints.maxWidth < 600) {
        return const ViewResumeMobile();
      } else {
        return ViewResumeDesktop(resumeID: widget.resumeID);
      }
    });
  }
}

class ViewResumeDesktop extends StatefulWidget {
  final int resumeID;
  const ViewResumeDesktop({super.key, required this.resumeID});

  @override
  State<ViewResumeDesktop> createState() => _ViewResumeDesktopState();
}

class _ViewResumeDesktopState extends State<ViewResumeDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const DashboardHeader(),
            ResumeViewer(resumeID: widget.resumeID),
          ],
        ),
      ),
    );
  }
}

class ResumeViewer extends StatefulWidget {
  final int resumeID;
  const ResumeViewer({super.key, required this.resumeID});

  @override
  State<ResumeViewer> createState() => _ResumeViewerState();
}

class _ResumeViewerState extends State<ResumeViewer> {
  late GeneratedResume? resume;
  bool isLoading = true;
  bool isError = false;
  bool canDownload = false;

  // is Bought
  Future<bool> isBought(GeneratedResume resume) async {
    var isBought = await DatabaseService().isTemplateBought(resume.templateName);
    if (isBought.isDefinedAndNotNull) {
      return isBought!.isBought;
    } else {
      return false;
    }
  }

  // is subscriber
  Future<bool> isSubscriber() async {
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

  Future<void> fetchSingleResume() async {
    isLoading = true;
    setState(() {});

    try {
      var resumeFetched = await DatabaseService().fetchSingleResume(widget.resumeID);
      resume = resumeFetched;
    } catch (e) {
      await Fluttertoast.showToast(msg: 'Something went wrong...', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red.withOpacity(0.8), textColor: Colors.white);
    }

    isLoading = false;
    setState(() {});
  }

  // initial setup
  Future<void> init() async {
    fetchSingleResume().then((value) {
      return isSubscriber();
    }).then((value) {
      if (value) {
        return Future(() => true);
      } else {
        return isBought(resume!);
      }
    }).then((value) {
      canDownload = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: BackButtonApp(onPressed: () {
                    context.popRoute(ViewResume(resumeID: widget.resumeID));
                  }),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 50),
                  child: Image.network(
                    resume!.resumeLink.imageUrl,
                  ),
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: EditButton(onPressed: () {
                        context.pushRoute(CvMakerRoute(resumeID: widget.resumeID, templateName: 'Edit'));
                      }),
                    ),
                    SizedBox(
                      width: 200,
                      child: canDownload
                          ? DownloadButton(onPressed: () {
                              downloadFile(resume!.resumeLink.pdfUrl, resume!.resumeLink.pdfUrl);
                            })
                          : BuyButton(
                              onPressed: () {},
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

///
///
///
///
///
///
class ViewResumeMobile extends StatefulWidget {
  const ViewResumeMobile({super.key});

  @override
  State<ViewResumeMobile> createState() => _ViewResumeMobileState();
}

class _ViewResumeMobileState extends State<ViewResumeMobile> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

///
///
///
///
///
///
class DownloadButton extends StatelessWidget {
  final void Function() onPressed;

  const DownloadButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.fromLTRB(20, 25, 20, 25)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.download, color: Colors.white),
          SizedBox(width: 8.0),
          Text('Download PDF', style: TextStyle(color: Colors.white, fontSize: 16.0)),
        ],
      ),
    );
  }
}

// Edit Button
class EditButton extends StatelessWidget {
  final void Function() onPressed;

  const EditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.fromLTRB(20, 25, 20, 25)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, color: Colors.blue),
          SizedBox(width: 8.0),
          Text('Edit', style: TextStyle(color: Colors.blue, fontSize: 16.0)),
        ],
      ),
    );
  }
}

// Buy Now Button

class BuyButton extends StatelessWidget {
  final void Function() onPressed;

  const BuyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.fromLTRB(20, 25, 20, 25)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.download, color: Colors.white),
          SizedBox(width: 8.0),
          Text('Buy Now', style: TextStyle(color: Colors.white, fontSize: 16.0)),
        ],
      ),
    );
  }
}
