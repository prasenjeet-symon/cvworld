import 'package:cvworld/client/datasource/http/http.manager.dart';
import 'package:cvworld/client/utils.dart';
import 'package:cvworld/dashboard/datasource/http/http.manager.admin.dart' as httpManagerAdmin;
import 'package:cvworld/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  await httpManagerAdmin.ApplicationToken.getInstance().bootUp();
  await ApplicationToken.getInstance().bootUp();
  await Authentication().bootUp();
  await TutorialStatus().bootUp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: goRouter);
  }
}
