import 'package:flutter/material.dart';
import '../../core/widgets/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900)),
        centerTitle: false,
        titleSpacing: 30,
      ),
        bottomNavigationBar: bottomNavigationBar(2, context)
    );
  }
}
