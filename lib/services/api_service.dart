import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://46.101.186.244:7150";

  static Future<http.Response> search(String path) {
    final url = Uri.parse('$baseUrl/api/Medication/search/{search}');
    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"path": path}),
    );
  }

}
