import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/client/datasource.dart';
import 'package:flutter_client/client/utils.dart';
import 'package:flutter_client/routes/router.gr.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          // ignore: sized_box_for_whitespace
          Container(
            width: 1000,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.4), width: 0.4))),
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                  child: Row(
                    children: [
                      const Expanded(child: Text('Resumes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27))),
                      TextButton(style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(40, 20, 40, 20)), onPressed: () => context.pushRoute(const MarketPlacePage()), child: const Row(children: [Icon(Icons.add), Text('Create')]))
                    ],
                  ),
                ),
                const DashboardBodyContent()
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class DashboardBodyContent extends StatefulWidget {
  const DashboardBodyContent({super.key});

  @override
  State<DashboardBodyContent> createState() => _DashboardBodyContentState();
}

class _DashboardBodyContentState extends State<DashboardBodyContent> {
  List<GeneratedResume> resumes = [];
  bool isLoading = true;
  bool isError = false;

  fetchAllCreatedResume() async {
    isLoading = true;
    setState(() {});

    try {
      var resumesFetched = await DatabaseService().fetchAllGeneratedResumeOfUser();
      resumes = resumesFetched ?? [];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> deleteResume(int id) async {
    // delete resume
    var index = resumes.indexWhere((element) => element.id == id);
    if (index != -1) {
      resumes.removeAt(index);
      setState(() {});

      await DatabaseService().deleteResume(id);
    }
  }

  downloadResume(int id) {
    var targetResume = resumes.firstWhere((element) => element.id == id);
    downloadFile(targetResume.resumeLink.pdfUrl, targetResume.resumeLink.pdfUrl);
  }

  editResume(BuildContext ctx, int id) {
    // ignore: use_build_context_synchronously
    ctx.pushRoute(CvMakerRoute(resumeID: id, templateName: 'Edit'));
  }

  @override
  void initState() {
    super.initState();
    fetchAllCreatedResume();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == false && resumes.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ignore: avoid_unnecessary_containers
            Container(
              child: SvgPicture.asset(
                'assets/no_resume.svg',
                fit: BoxFit.cover,
                width: 90,
                height: 120,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: const Text(
                'Your shining professional image',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: const Text(
                'Custom-built, amazing resumes. Empower your job search in just a few clicks!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                onPressed: () => {context.pushRoute(const MarketPlacePage())},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add), Text('Create')],
                ),
              ),
            )
          ],
        ),
      );
    } else if (isLoading == false && resumes.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 45, 0, 45),
        child: Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 20, // Spacing between the children horizontally
          runSpacing: 20, // Spacing between the lines vertically
          children: [
            ...resumes.map((e) => CreatedResumeItem(
                  deleteFunction: deleteResume,
                  downloadFunction: downloadResume,
                  editFunction: (int id) => editResume(context, id),
                  resume: e,
                ))
          ],
        ),
      );
    } else {
      return const Center(
        child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()),
      );
    }
  }
}

class CreatedResumeItem extends StatefulWidget {
  void Function(int id) deleteFunction;
  void Function(int id) editFunction;
  void Function(int id) downloadFunction;
  GeneratedResume resume;

  CreatedResumeItem({super.key, required this.deleteFunction, required this.downloadFunction, required this.editFunction, required this.resume});

  @override
  State<CreatedResumeItem> createState() => _CreatedResumeItemState();
}

class _CreatedResumeItemState extends State<CreatedResumeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.pushRoute(ViewResume(resumeID: widget.resume.id));
              },
              child: Container(
                padding: const EdgeInsets.all(1),
                child: Image.network(widget.resume.resumeLink.imageUrl),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Text('${widget.resume.resume.profession}.pdf', style: const TextStyle(fontSize: 20)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TextButton.icon(
                  onPressed: () {
                    context.pushRoute(ViewResume(resumeID: widget.resume.id));
                  },
                  icon: const Icon(Icons.remove_red_eye_sharp),
                  label: const Text('View Resume'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TextButton.icon(
                  onPressed: () => context.pushRoute(ViewResume(resumeID: widget.resume.id)),
                  icon: const Icon(Icons.download),
                  label: const Text('Download Resume'),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TextButton.icon(onPressed: () => widget.deleteFunction(widget.resume.id), icon: const Icon(Icons.delete), label: const Text('Delete Resume')),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TextButton.icon(onPressed: () => widget.editFunction(widget.resume.id), icon: const Icon(Icons.edit), label: const Text('Edit Resume')),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
