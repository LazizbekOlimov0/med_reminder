import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService{
  static const String baseUrl = "https://10.10.1.9:7190/api/Users/login";

  static Future<http.Response> login(String email, String password){
    final url = Uri.parse('$baseUrl/login');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }
}