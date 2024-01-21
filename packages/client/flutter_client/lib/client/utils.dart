// a function to determine the page width given the context
import 'package:cvworld/client/datasource.dart';
import 'package:cvworld/routes/router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher.dart';

// SOME APPLICATION CONSTANTS
class Constants {
  static const String appName = 'CV World';
  static const String appVersion = '1.0';
  static const int debounceTime = 1000;
  static const googleClientIdAndroid = '526173453078-5bt1icrr45ub28erv39j62qkpnd5473m.apps.googleusercontent.com';
  static const int breakPoint = 600;
  static const refreshSeconds = 5;
  static const String dummyProfilePic = 'https://th.bing.com/th/id/OIP.9B2RxsHDB_s7FZT0mljnhQHaHa?rs=1&pid=ImgDetMain';
}

double pageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width >= Constants.breakPoint ? MediaQuery.of(context).size.width * 0.7 : MediaQuery.of(context).size.width;
}

int flexNumber(BuildContext context) {
  return MediaQuery.of(context).size.width >= Constants.breakPoint ? 1 : 0;
}

Future<void> downloadFile(String url, String fileName) async {
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  )) {
  } else {
    throw 'Could not launch $url';
  }
}

void openLinkInBrowser(String url) async {
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  )) {
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> logOutUser(BuildContext context) async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: 'JWT');
  // ignore: use_build_context_synchronously
  context.pushNamed(RouteNames.signin);
}

class BackButtonApp extends StatelessWidget {
  final void Function() onPressed;

  const BackButtonApp({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.fromLTRB(25, 15, 25, 15)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          SizedBox(width: 8.0),
          Text(
            'Back',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

String toUtcJsonDateTimeFromDateTime(DateTime dateTime) {
  DateTime utcDateTime = dateTime.toUtc();
  String jsonDateTime = utcDateTime.toIso8601String();
  return jsonDateTime;
}

class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException(this.message);

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}

// For no user exist
class NoUserException implements Exception {
  final String message;

  NoUserException(this.message);

  @override
  String toString() => 'NoUserException: $message';
}

// For the week password
class WeekPasswordException implements Exception {
  final String message;

  WeekPasswordException(this.message);

  @override
  String toString() => 'WeekPasswordException: $message';
}

// For the wrong password exception
class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException(this.message);

  @override
  String toString() => 'WrongPasswordException: $message';
}

// Input fields are required
class RequiredFieldException implements Exception {
  final String message;

  RequiredFieldException(this.message);

  @override
  String toString() => 'RequiredFieldException: $message';
}

enum PlatformType { mobile, desktop, web }

PlatformType detectPlatformType() {
  if (kIsWeb) {
    return PlatformType.web;
  } else if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    return PlatformType.mobile;
  } else {
    return PlatformType.desktop;
  }
}

///
///
///
/// Widget to choose profile picture

class ImagePickerWidget extends StatefulWidget {
  final Function(List<PlatformFile>) onImageSelected;

  const ImagePickerWidget({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
      allowCompression: true,
    );

    if (result != null) {
      widget.onImageSelected(result.files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          ),
          onPressed: _pickImage,
          child: const Text('Upload profile picture'),
        ),
      ],
    );
  }
}

///
///
///
///
class ImageCard extends StatefulWidget {
  const ImageCard({super.key});

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  User? user;
  bool isLoading = true;

  Future<void> _uploadProfile(List<PlatformFile> pickedFiles) async {
    if (pickedFiles.isEmpty) {
      return;
    }

    setState(() => isLoading = true);

    User? latestUser = await DatabaseService().updateUserProfilePicture(pickedFiles.first.name, pickedFiles.first.bytes, pickedFiles.first.path);

    setState(() {
      user = latestUser;
      isLoading = false;
    });

    MySubjectSingleton.instance.dashboardHeaderSubject.add(true);
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().fetchUser().then((value) => user = value).then((value) => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withOpacity(0.03),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: isLoading ? const CircularProgressIndicator(strokeWidth: 2.0, color: Colors.black, backgroundColor: Colors.white) : CircleAvatar(backgroundImage: NetworkImage(user!.profilePicture), radius: 50),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Change your profile picture', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ImagePickerWidget(
                    onImageSelected: (List<PlatformFile> files) {
                      _uploadProfile(files);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Get timezone
Future<String> getCurrentTimeZone() async {
  return await FlutterTimezone.getLocalTimezone();
}

class MySubjectSingleton {
  // Private constructor
  MySubjectSingleton._();

  // Single instance of the class
  static final MySubjectSingleton _instance = MySubjectSingleton._();

  // Getter to access the instance
  static MySubjectSingleton get instance => _instance;

  // Behavior subject for some data
  final BehaviorSubject<bool> _dashboardHeaderSubject = BehaviorSubject<bool>.seeded(false);

  // Getter to access the behavior subject
  BehaviorSubject<bool> get dashboardHeaderSubject => _dashboardHeaderSubject;

  // Dispose method to close the subject when it's no longer needed
  void dispose() {
    _dashboardHeaderSubject.close();
  }
}
