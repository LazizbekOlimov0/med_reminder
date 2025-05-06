import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class AuthController {
  Future<bool> login(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://10.10.1.9:7190/api/Users/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint("Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Login exception: $e");
      return false;
    }
  }
}
