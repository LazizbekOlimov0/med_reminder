import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:med_reminder/models/medication.dart';

class ApiService {
  // Replace with your actual API base URL
  static const String baseUrl = 'https://your-api-url.com/api';
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add authorization header if needed
    // 'Authorization': 'Bearer ${your_token}',
  };

  /// Create a new medicine
  static Future<http.Response> createMedicine(MedicineModel medicine) async {
    try {
      final url = Uri.parse('$baseUrl/medicines');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(medicine.toJson()),
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to create medicine: $e');
    }
  }

  /// Get all medicines for a user
  static Future<http.Response> getMedicines(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/medicines?userId=$userId');

      final response = await http.get(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to get medicines: $e');
    }
  }

  /// Get a specific medicine by ID
  static Future<http.Response> getMedicineById(String medicineId) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/$medicineId');

      final response = await http.get(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to get medicine: $e');
    }
  }

  /// Update an existing medicine
  static Future<http.Response> updateMedicine(String medicineId, MedicineModel medicine) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/$medicineId');

      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(medicine.toJson()),
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to update medicine: $e');
    }
  }

  /// Delete a medicine
  static Future<http.Response> deleteMedicine(String medicineId) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/$medicineId');

      final response = await http.delete(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to delete medicine: $e');
    }
  }

  /// Search for medicines by name
  static Future<http.Response> searchMedicine(String medicineName) async {
    try {
      final encodedName = Uri.encodeComponent(medicineName);
      final url = Uri.parse('$baseUrl/medicines/search?name=$encodedName');

      final response = await http.get(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to search medicine: $e');
    }
  }

  /// Get active medicines for a user
  static Future<http.Response> getActiveMedicines(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/active?userId=$userId');

      final response = await http.get(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to get active medicines: $e');
    }
  }

  /// Toggle medicine active status
  static Future<http.Response> toggleMedicineStatus(String medicineId, bool isActive) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/$medicineId/toggle-status');

      final response = await http.patch(
        url,
        headers: _headers,
        body: jsonEncode({'isActive': isActive}),
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to toggle medicine status: $e');
    }
  }

  /// Get medicines by date range
  static Future<http.Response> getMedicinesByDateRange(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      final start = startDate.toIso8601String();
      final end = endDate.toIso8601String();
      final url = Uri.parse('$baseUrl/medicines/date-range?userId=$userId&startDate=$start&endDate=$end');

      final response = await http.get(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to get medicines by date range: $e');
    }
  }

  /// Mark dose as taken
  static Future<http.Response> markDoseAsTaken(
      String medicineId,
      String doseTime,
      DateTime takenDate,
      ) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/$medicineId/dose-taken');

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'doseTime': doseTime,
          'takenDate': takenDate.toIso8601String(),
          'status': 'taken',
        }),
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to mark dose as taken: $e');
    }
  }

  /// Get dose history for a medicine
  static Future<http.Response> getDoseHistory(String medicineId) async {
    try {
      final url = Uri.parse('$baseUrl/medicines/$medicineId/dose-history');

      final response = await http.get(
        url,
        headers: _headers,
      ).timeout(timeoutDuration);

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to get dose history: $e');
    }
  }

  /// Helper method to parse medicine list from response
  static List<MedicineModel> parseMedicineList(String responseBody) {
    try {
      final List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((json) => MedicineModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to parse medicine list: $e');
    }
  }

  /// Helper method to parse single medicine from response
  static MedicineModel parseMedicine(String responseBody) {
    try {
      final Map<String, dynamic> json = jsonDecode(responseBody);
      return MedicineModel.fromJson(json);
    } catch (e) {
      throw Exception('Failed to parse medicine: $e');
    }
  }

  /// Helper method to check if response is successful
  static bool isSuccessful(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Helper method to handle error responses
  static String getErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> errorJson = jsonDecode(response.body);
      return errorJson['message'] ?? errorJson['error'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
    }
  }
}