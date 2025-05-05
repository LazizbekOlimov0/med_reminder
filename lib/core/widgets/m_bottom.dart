import 'package:flutter/material.dart';

class MBottom extends StatelessWidget {

  String text;
  VoidCallback func;

  MBottom({required this.func, required this.text, super.key});

  @override
  Widget build(BuildContext context) {

    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return MaterialButton(
      onPressed: (){},
      height: sizeHeight * 0.08,
      minWidth: sizeWidth,
      color: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(width: 2, color: Colors.blue.shade700),
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
