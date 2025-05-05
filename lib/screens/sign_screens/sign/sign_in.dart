import 'package:flutter/material.dart';
import 'package:med_reminder/screens/sign_screens/reset/forgot_password.dart';

import '../../../core/widgets/input_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          height: sizeHeight,
          width: sizeWidth,
          color: Colors.blue.shade50,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Text(" Log in",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: sizeHeight * 0.05)
                ),
                textField('Email address', controllerEmail),
                textField("Password", controllerPassword),
                MaterialButton(
                  onPressed: (){},
                  height: sizeHeight * 0.08,
                  minWidth: sizeWidth,
                  color: Colors.blueAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(width: 2, color: Colors.blue.shade700),
                  ),
                  child: Text("Log in", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword())),
                        child: Text("Forgot password?", style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 10),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
