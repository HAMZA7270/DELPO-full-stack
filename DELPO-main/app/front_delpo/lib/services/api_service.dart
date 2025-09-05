import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  // Base URL for your Laravel API
  static const String baseUrl = ApiConstants.baseUrl;
  
  // Authentication token (will be set after login)
  static String? _authToken;
  
  // Set authentication token
  static void setAuthToken(String token) {
    _authToken = token;
  }
  
  // Clear authentication token
  static void clearAuthToken() {
    _authToken = null;
  }
  
  // Get current auth token
  static String? get authToken => _authToken;
  
  // Headers for API requests
  static Map<String, String> get headers {
    final baseHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      baseHeaders['Authorization'] = 'Bearer $_authToken';
    }
    
    return baseHeaders;
  }

  // Process API response
  static Map<String, dynamic> _processResponse(http.Response response) {
    final responseData = json.decode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      // Handle API error responses
      String errorMessage = 'Unknown error occurred';
      
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('message')) {
          errorMessage = responseData['message'];
        } else if (responseData.containsKey('error')) {
          errorMessage = responseData['error'];
        } else if (responseData.containsKey('errors')) {
          // Handle validation errors
          final errors = responseData['errors'];
          if (errors is Map<String, dynamic>) {
            errorMessage = errors.values.first.first ?? errorMessage;
          }
        }
      }
      
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e', 0);
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e', 0);
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e', 0);
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e', 0);
    }
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;
  
  ApiException(this.message, this.statusCode);
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
