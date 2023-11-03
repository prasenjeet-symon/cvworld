import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard-desktop.dart';
import 'package:cvworld/client/pages/dashboard/dashboard/dashboard-mobile.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/routes/router.gr.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < Constants.breakPoint) {
        return const DashboardMobile();
      } else {
        return const DashboardDesktop();
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
class DashboardContentLogic {
  List<GeneratedResume> resumes = [];
  Function setStateCallback; // Callback to call setState in the parent widget
  bool isLoading = false;

  DashboardContentLogic({required this.setStateCallback});

  // Fetch all created resumes for the current user from the database
  Future<List<GeneratedResume>> fetchAllCreatedResume() async {
    try {
      isLoading = true;
      setStateCallback();
      var resumesFetched = await DatabaseService().fetchAllGeneratedResumeOfUser();
      resumes = resumesFetched ?? [];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    isLoading = false;
    setStateCallback();

    return resumes;
  }

  // Delete a resume with the given ID from the database
  Future<void> deleteResume(int id) async {
    // Find the index of the resume to be deleted
    var index = resumes.indexWhere((element) => element.id == id);
    if (index != -1) {
      // Create a copy of the resumes list
      var resumesCopy = List.of(resumes);
      // Remove the resume from the local list immediately
      resumes.removeAt(index);
      setStateCallback();

      try {
        await DatabaseService().deleteResume(id); // Attempt to delete the resume from the database
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }

        // If there's an error deleting the resume from the database, revert to the original list
        resumes = resumesCopy;
        setStateCallback();
      }
    }
  }

  // Download the resume with the given ID as a PDF file
  void downloadResume(int id) {
    var targetResume = resumes.firstWhere((element) => element.id == id);
    downloadFile(targetResume.resumeLink.pdfUrl, targetResume.resumeLink.pdfUrl);
  }

  // Edit the resume with the given ID by navigating to the CvMakerRoute
  void editResume(BuildContext ctx, int id) {
    // ignore: use_build_context_synchronously
    ctx.pushRoute(CvMakerRoute(resumeID: id, templateName: 'Edit'));
  }
}

/// Resume card
///
///
///
///
///
///
class CreatedResumeItem extends StatelessWidget {
  final void Function(int id) deleteFunction;
  final void Function(int id) editFunction;
  final void Function(int id) downloadFunction;
  final GeneratedResume resume;
  final double width;

  const CreatedResumeItem({
    super.key,
    required this.deleteFunction,
    required this.editFunction,
    required this.downloadFunction,
    required this.resume,
    required this.width,
  });

  Future<void> _confirmDeleteResumeItem(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this resume?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteFunction(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final resumeImage = GestureDetector(
      onTap: () => context.pushRoute(ViewResume(resumeID: resume.id)),
      child: Container(
        padding: const EdgeInsets.all(1),
        child: Image.network(resume.resumeLink.imageUrl, width: width, fit: BoxFit.cover),
      ),
    );

    final resumeDetails = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Text('${resume.resume.profession}.pdf', style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 5),
          ResumeActionButton(
            onPressed: () => context.pushRoute(ViewResume(resumeID: resume.id)),
            icon: Icons.remove_red_eye_sharp,
            label: 'View Resume',
          ),
          ResumeActionButton(
            onPressed: () {
              _confirmDeleteResumeItem(context, resume.id);
            },
            icon: Icons.delete,
            label: 'Delete Resume',
          ),
          ResumeActionButton(
            onPressed: () => editFunction(resume.id),
            icon: Icons.edit,
            label: 'Edit Resume',
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.all(10),
      width: width * 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          resumeImage,
          resumeDetails,
        ],
      ),
    );
  }
}

class ResumeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const ResumeActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(3),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

/// No resume card
///
///
///
///
///
///
class ShiningImageSection extends StatelessWidget {
  const ShiningImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = detectPlatformType() == PlatformType.mobile;
    final double imageSize = isMobile ? 100 : 200;
    final double titleFontSize = isMobile ? 20 : 30;
    final double descriptionFontSize = isMobile ? 15 : 16;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShiningImage(imageSize: imageSize),
          ShiningImageTitle(titleFontSize: titleFontSize),
          ShiningImageDescription(descriptionFontSize: descriptionFontSize),
          const ShiningImageCreateButton(),
        ],
      ),
    );
  }
}

class ShiningImage extends StatelessWidget {
  final double imageSize;

  const ShiningImage({super.key, required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/no_resume.svg',
      fit: BoxFit.cover,
      width: imageSize,
      height: imageSize,
    );
  }
}

class ShiningImageTitle extends StatelessWidget {
  final double titleFontSize;

  const ShiningImageTitle({super.key, required this.titleFontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text(
        'Your shining professional image',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: titleFontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ShiningImageDescription extends StatelessWidget {
  final double descriptionFontSize;

  const ShiningImageDescription({super.key, required this.descriptionFontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 30),
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Text(
        'Custom-built, amazing resumes. Empower your job search in just a few clicks!',
        style: TextStyle(fontSize: descriptionFontSize, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ShiningImageCreateButton extends StatelessWidget {
  const ShiningImageCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.fromLTRB(35, 12, 35, 12)),
        onPressed: () => context.pushRoute(const MarketPlacePage()),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text(
              'Create',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
