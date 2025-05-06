import 'package:flutter/material.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_in.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_up.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(_createRoute());
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 1000),
      pageBuilder: (context, animation, secondaryAnimation) => SignUp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: sizeHeight,
          width: sizeWidth,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: sizeHeight,
                width: sizeWidth,
                child: Image(image: AssetImage("assets/images/img.png"),fit: BoxFit.cover),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Med",
                          style: TextStyle(color: Colors.blue.shade900, fontSize: sizeHeight * 0.08, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 10),
                      Text("Reminder",
                          style: TextStyle(color: Colors.blue.shade900, fontSize: sizeHeight * 0.08, fontWeight: FontWeight.bold)
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
