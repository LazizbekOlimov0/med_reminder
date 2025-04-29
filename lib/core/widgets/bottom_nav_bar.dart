import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:med_reminder/screens/main_screen/add_page.dart';
import 'package:med_reminder/screens/main_screen/home_page.dart';
import 'package:med_reminder/screens/main_screen/profile_page.dart';

BottomNavigationBar bottomNavigationBar(int active, BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    onTap: (int index) {
      switch (index) {
        case 0:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        case 1:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddPage()),
            );
          }
        case 2:
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
      }
    },
    items: [
      BottomNavigationBarItem(
        icon:
            active == 0
                ? Icon(FontAwesomeIcons.pills, color: Colors.black)
                : Icon(FontAwesomeIcons.pills, color: Colors.black),
        label: "",
      ),
      BottomNavigationBarItem(
        icon:
            active == 1
                ? Icon(Icons.add, color: Colors.black)
                : Icon(Icons.add, color: Colors.black),
        label: "",
      ),
      BottomNavigationBarItem(
        icon:
            active == 2
                ? Icon(Icons.person, color: Colors.black)
                : Icon(Icons.person, color: Colors.black),
        label: "",
      ),
    ],
  );
}
