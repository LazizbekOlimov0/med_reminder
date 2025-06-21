import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:med_reminder/models/medication.dart';

class ApiService {
  static const String baseUrl = 'https://your-api-url.com/api';
  static const Duration timeout = Duration(seconds: 30);

  // Helper method to create headers
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Helper method to handle HTTP errors
  static void _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw ApiException('Bad Request: Invalid data sent to server', response.statusCode);
      case 401:
        throw ApiException('Unauthorized: Please check your credentials', response.statusCode);
      case 403:
        throw ApiException('Forbidden: Access denied', response.statusCode);
      case 404:
        throw ApiException('Not Found: The requested resource was not found', response.statusCode);
      case 500:
        throw ApiException('Internal Server Error: Please try again later', response.statusCode);
      case 503:
        throw ApiException('Service Unavailable: Server is temporarily unavailable', response.statusCode);
      default:
        throw ApiException('HTTP Error: ${response.statusCode} - ${response.reasonPhrase}', response.statusCode);
    }
  }

  static Future<http.Response> createMedicine(MedicineModel medicine) async {
    final url = Uri.parse('$baseUrl/Medication/create');

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode(medicine.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        _handleHttpError(response);
        return response; // This line won't be reached, but needed for return type
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.', 0);
    } on http.ClientException {
      throw ApiException('Network error. Please try again.', 0);
    } on FormatException {
      throw ApiException('Invalid data format.', 0);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to create medicine: ${e.toString()}', 0);
    }
  }

  static Future<List<MedicineModel>> getAllMedicines({String? userId}) async {
    String url = '$baseUrl/Medication/get-all';

    // Add userId as query parameter if provided
    if (userId != null && userId.isNotEmpty) {
      url += '?userId=$userId';
    }

    final uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Check if response is empty
        if (responseBody.isEmpty) {
          return <MedicineModel>[];
        }

        final dynamic decodedData = jsonDecode(responseBody);

        // Handle different response formats
        List<dynamic> data;
        if (decodedData is Map<String, dynamic>) {
          // If the response is wrapped in an object (e.g., {"data": [...], "success": true})
          if (decodedData.containsKey('data')) {
            data = decodedData['data'] as List<dynamic>;
          } else if (decodedData.containsKey('medicines')) {
            data = decodedData['medicines'] as List<dynamic>;
          } else {
            // If it's a single object, wrap it in a list
            data = [decodedData];
          }
        } else if (decodedData is List) {
          data = decodedData;
        } else {
          throw ApiException('Unexpected response format', response.statusCode);
        }

        return data.map((item) {
          try {
            return MedicineModel.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            throw ApiException('Failed to parse medicine data: ${e.toString()}', response.statusCode);
          }
        }).toList();
      } else {
        _handleHttpError(response);
        return <MedicineModel>[]; // This line won't be reached, but needed for return type
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.', 0);
    } on http.ClientException {
      throw ApiException('Network error. Please try again.', 0);
    } on FormatException catch (e) {
      throw ApiException('Invalid JSON response: ${e.toString()}', 0);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch medicines: ${e.toString()}', 0);
    }
  }

  // Additional helper methods
  static Future<http.Response> updateMedicine(String medicineId, MedicineModel medicine) async {
    final url = Uri.parse('$baseUrl/Medication/update/$medicineId');

    try {
      final response = await http.put(
        url,
        headers: _getHeaders(),
        body: jsonEncode(medicine.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        _handleHttpError(response);
        return response;
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.', 0);
    } on http.ClientException {
      throw ApiException('Network error. Please try again.', 0);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to update medicine: ${e.toString()}', 0);
    }
  }

  static Future<http.Response> deleteMedicine(String medicineId) async {
    final url = Uri.parse('$baseUrl/Medication/delete/$medicineId');

    try {
      final response = await http.delete(
        url,
        headers: _getHeaders(),
      ).timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response;
      } else {
        _handleHttpError(response);
        return response;
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.', 0);
    } on http.ClientException {
      throw ApiException('Network error. Please try again.', 0);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to delete medicine: ${e.toString()}', 0);
    }
  }

  static Future<MedicineModel?> getMedicineById(String medicineId) async {
    final url = Uri.parse('$baseUrl/Medication/get/$medicineId');

    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        return MedicineModel.fromJson(data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null; // Medicine not found
      } else {
        _handleHttpError(response);
        return null;
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.', 0);
    } on http.ClientException {
      throw ApiException('Network error. Please try again.', 0);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to fetch medicine: ${e.toString()}', 0);
    }
  }

  // Search medicines by name or other criteria
  static Future<List<MedicineModel>> searchMedicines(String searchQuery, {String? userId}) async {
    if (searchQuery.trim().isEmpty) {
      throw ApiException('Search query cannot be empty', 400);
    }

    // URL encode the search query to handle special characters
    final encodedQuery = Uri.encodeComponent(searchQuery.trim());
    String url = '$baseUrl/Medication/search/$encodedQuery';

    // Add userId as query parameter if provided
    if (userId != null && userId.isNotEmpty) {
      url += '?userId=$userId';
    }

    final uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: _getHeaders(),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Check if response is empty
        if (responseBody.isEmpty) {
          return <MedicineModel>[];
        }

        final dynamic decodedData = jsonDecode(responseBody);

        // Handle different response formats
        List<dynamic> data;
        if (decodedData is Map<String, dynamic>) {
          // If the response is wrapped in an object
          if (decodedData.containsKey('data')) {
            data = decodedData['data'] as List<dynamic>;
          } else if (decodedData.containsKey('medicines')) {
            data = decodedData['medicines'] as List<dynamic>;
          } else if (decodedData.containsKey('results')) {
            data = decodedData['results'] as List<dynamic>;
          } else {
            // If it's a single object, wrap it in a list
            data = [decodedData];
          }
        } else if (decodedData is List) {
          data = decodedData;
        } else {
          throw ApiException('Unexpected response format', response.statusCode);
        }

        return data.map((item) {
          try {
            return MedicineModel.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            throw ApiException('Failed to parse medicine data: ${e.toString()}', response.statusCode);
          }
        }).toList();
      } else if (response.statusCode == 404) {
        // No medicines found matching the search criteria
        return <MedicineModel>[];
      } else {
        _handleHttpError(response);
        return <MedicineModel>[];
      }
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.', 0);
    } on http.ClientException {
      throw ApiException('Network error. Please try again.', 0);
    } on FormatException catch (e) {
      throw ApiException('Invalid JSON response: ${e.toString()}', 0);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to search medicines: ${e.toString()}', 0);
    }
  }

  // Method to check API connectivity
  static Future<bool> checkConnectivity() async {
    try {
      final url = Uri.parse('$baseUrl/health'); // Assuming you have a health check endpoint
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

// Extension for easier error handling in UI
extension ApiResponseExtension on http.Response {
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  Map<String, dynamic>? get jsonBody {
    try {
      return jsonDecode(body) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }
}