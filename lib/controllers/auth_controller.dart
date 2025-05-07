import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthController {
  Future<bool> login(BuildContext context, String email, String password) async {
    try {
      final response = await ApiService.login(email, password);

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
