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
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none)),
          IconButton(onPressed: (){}, icon: Icon(Icons.edit_sharp)),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(2, context),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: BorderDirectional(
                  start: BorderSide(width: 2, color: Colors.blue.shade200),
                  end: BorderSide(width: 2, color: Colors.blue.shade200),
                  top: BorderSide(width: 2, color: Colors.blue.shade200),
                  bottom: BorderSide(width: 2, color: Colors.blue.shade200),
                )
              ),
              height: 200,
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(image: AssetImage("assets/images/pr.png"), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text("Mr Jon Due", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            
          ],
        ),
      ),
    );
  }
}
