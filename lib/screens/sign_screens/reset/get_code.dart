import 'package:flutter/material.dart';
import 'package:med_reminder/screens/sign_screens/sign/sign_in.dart';

import '../../../core/widgets/input_text_field.dart';

class GetCode extends StatefulWidget {
  const GetCode({super.key});

  @override
  State<GetCode> createState() => _GetCodeState();
}

class _GetCodeState extends State<GetCode> {

  TextEditingController controllerGetCode = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

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
                Text(" Get code",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: sizeHeight * 0.05)
                ),
                SizedBox(height: sizeHeight * 0.05),
                textField("Code", controllerGetCode),
                textField("New Password", controllerNewPassword),
                textField("Confirm Password", controllerConfirmPassword),
                MaterialButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn()), (Route<dynamic> route) => false),
                  height: sizeHeight * 0.08,
                  minWidth: sizeWidth,
                  color: Colors.blueAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(width: 2, color: Colors.blue.shade700),
                  ),
                  child: Text("Save password", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
