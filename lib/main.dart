import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/login/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
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
        appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0),
        scaffoldBackgroundColor: const Color(0xfff6f6f6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5872de)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
