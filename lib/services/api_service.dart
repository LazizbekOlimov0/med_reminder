import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  static const String baseUrl = "http://46.101.186.244:7150";

  static Future<http.Response> login(String email, String password){
    final url = Uri.parse('$baseUrl/api/Users/login');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }
}