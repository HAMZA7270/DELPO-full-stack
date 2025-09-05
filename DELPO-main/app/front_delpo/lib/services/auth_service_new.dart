import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
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
  
  // Check if user is authenticated
  static bool isAuthenticated() {
    return _authToken != null;
  }

  // Login user
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Attempting login for: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Save token if present
        if (responseData.containsKey('token')) {
          setAuthToken(responseData['token']);
          print('Token saved: ${responseData['token']}');
        }
        
        return responseData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Register user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      print('Attempting registration for: $email');
      
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );
      
      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Save token if present
        if (responseData.containsKey('token')) {
          setAuthToken(responseData['token']);
          print('Token saved after registration: ${responseData['token']}');
        }
        
        return responseData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  // Logout user
  static Future<void> logout() async {
    clearAuthToken();
  }
}
