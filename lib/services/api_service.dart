import 'package:http/http.dart' as http;

class ApiService{
  static const String baseUrl = "https://localhost:7190/api/Users/login";

  static Future<http.Response> login(String email, String password){
    final url = Uri.parse('$baseUrl/login');
    return http.post(
      url,
      headers: {"Content type": "application/json"},
      body: '{"email": "$email", "password": "$password"}',
    );
  }
}