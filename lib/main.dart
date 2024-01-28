import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/home/home_screen.dart';
import 'package:job_board_app/view/input/input_screen.dart';
import 'package:job_board_app/view/login/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Utils.initScreenSize(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Board',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InputScreen(),
    );
  }
}

