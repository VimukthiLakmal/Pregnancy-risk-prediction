import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pregnancy/firebase_options.dart';
import 'package:pregnancy/screens/home.dart';
import 'package:pregnancy/screens/landing.dart';
import 'package:pregnancy/screens/select.dart';
import 'package:pregnancy/screens/sign_in_screen.dart';
import 'package:pregnancy/screens/sign_up_one_screen.dart';
import 'package:pregnancy/screens/sign_up_two_screen.dart';
import 'package:pregnancy/theme.dart';
import '../screens/calendar.dart';

Future<void> main() async {
  // ignore: unused_local_variable
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent // set status bar color
      ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pregnancy',
      theme: theme(),
      home: const LandingPage(),
      routes: {
        '/login': (BuildContext context) => const SignInScreen(),
        '/register': (BuildContext context) => const SignUpScreen(),
        '/registert': (BuildContext context) => const SignUpTScreen(),
        '/select': (BuildContext context) => const SelectScreen(),
        '/home': (BuildContext context) => HomeScreen(),
        '/cal': (BuildContext context) => const Cal(),
      },
    );
  }
}
