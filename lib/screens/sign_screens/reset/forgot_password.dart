import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/input_text_field.dart';

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
                Text(
                  " Forgot Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: sizeHeight * 0.05,
                  ),
                ),
                SizedBox(height: sizeHeight * 0.05),
                textField('Email address', controllerEmail),
                MaterialButton(
                  onPressed:
                      () => context.go('/signIn/forgotPassword/getCode'),
                  height: sizeHeight * 0.08,
                  minWidth: sizeWidth,
                  color: Colors.blueAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(width: 2, color: Colors.blue.shade700),
                  ),
                  child: Text(
                    "Get code",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
