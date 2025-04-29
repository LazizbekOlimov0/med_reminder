import 'package:flutter/material.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_in.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_up.dart';
import 'package:med_reminder/screens/welcome.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
