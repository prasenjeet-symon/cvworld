import 'dart:js_interop';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/pages/dashboard/header.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_client/client/datasource.dart';

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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return const ViewResumeMobile();
      } else {
        return ViewResumeDesktop(
          resumeID: widget.resumeID,
        );
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
            ResumeViewer(
              resumeID: widget.resumeID,
            )
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
  late List<GeneratedResume> resume = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> fetchSingleResume() async {
    isLoading = true;
    setState(() {});

    try {
      var resumeFetched =
          await DatabaseService().fetchSingleResume(widget.resumeID);
      resume = [];
      resume.add((resumeFetched as GeneratedResume));
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
    setState(() {});
  }

  @override
  void initState() {
    print(widget.resumeID);
    fetchSingleResume();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || resume.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
                    context.back();
                  }),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 50),
                  child: Image.network(resume[0].resume.imageUrl),
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: 200,
                      child: DownloadButton(onPressed: () {
                        downloadFile(
                            resume[0].resume.pdfUrl, resume[0].resume.pdfUrl);
                      }),
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

/** 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
class ViewResumeMobile extends StatefulWidget {
  const ViewResumeMobile({super.key});

  @override
  State<ViewResumeMobile> createState() => _ViewResumeMobileState();
}

class _ViewResumeMobileState extends State<ViewResumeMobile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

/**  
 * 
 * 
 * 
 * 
 * 
 */
class DownloadButton extends StatelessWidget {
  final void Function() onPressed;

  const DownloadButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 25)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.download,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Text(
            'Download PDF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
