import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthController {
  Future<bool> search(BuildContext context, String path) async {
    try {
      final response = await ApiService.search(path);

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
