import 'package:flutter/material.dart';
import 'package:med_reminder/router/app_router.dart';
import 'package:med_reminder/screens/main_screen/add_page.dart';
import 'package:med_reminder/screens/main_screen/profile_page.dart';
import 'package:med_reminder/screens/welcome.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}