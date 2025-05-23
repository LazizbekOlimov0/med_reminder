import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class Main extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const Main({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.pills, color: Colors.black),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.black),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: "",
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          if (currentIndex != index) {
            String page = switch (index) {
              0 => "/home",
              1 => "/add",
              2 => "/profile",
              _ => "/main",
            };
            context.go(page);
          }
        },
      ),
    );
  }
}