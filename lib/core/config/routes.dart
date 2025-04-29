import 'package:flutter/material.dart';
import 'package:med_reminder/screens/main_screen/add_page.dart';
import 'package:med_reminder/screens/main_screen/home_page.dart';
import 'package:med_reminder/screens/main_screen/profile_page.dart';

sealed class AppRoutes{
  static const home = "home";
  static const add = "add";
  static const profile = "profile";

  static Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    AppRoutes.home: (context) => const HomePage(),
    AppRoutes.add: (context) => const AddPage(),
    AppRoutes.profile: (context) => const ProfilePage(),
  };
}