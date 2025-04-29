import 'package:flutter/material.dart';
import 'package:med_reminder/screens/sign_screens/reset/get_code.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_in.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController controllerEmail = TextEditingController();

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
                Text(" Forgot Password",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: sizeHeight * 0.05)
                ),
                SizedBox(height: sizeHeight * 0.05),
                TextField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Email address',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                MaterialButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GetCode())),
                  height: sizeHeight * 0.08,
                  minWidth: sizeWidth,
                  color: Colors.blueAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(width: 2, color: Colors.blue.shade700),
                  ),
                  child: Text("Get code", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
