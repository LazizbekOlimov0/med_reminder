import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://46.101.186.244:7150";

  static Future<http.Response> login(String email, String password) {
    final url = Uri.parse('$baseUrl/api/Users/login');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  static Future<http.Response> search(String path) {
    final url = Uri.parse('$baseUrl/api/Medication/search/{search}');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"path": path}),
    );
  }

  static Future<http.Response> registiration(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) {
    final url = Uri.parse('$baseUrl/api/Users/registration');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
      }),
    );
  }
}
