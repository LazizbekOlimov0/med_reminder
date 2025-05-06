import 'package:flutter/material.dart';

textField(String text, TextEditingController controller){
  return TextField(
    controller: controller,
    obscureText: (text == "Password") ? true : false,
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
      hintText: text,
      hintStyle: const TextStyle(color: Colors.grey),
    ),
  );
}