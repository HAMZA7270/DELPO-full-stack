import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:8000/api';
  static String? _authToken;
  static Map<String, dynamic>? _currentUser;
  
  // Set authentication token
  static void setAuthToken(String token) {
    _authToken = token;
  }
  
  // Set current user data
  static void setCurrentUser(Map<String, dynamic> user) {
    _currentUser = user;
  }
  
  // Get current user
  static Map<String, dynamic>? get currentUser => _currentUser;
  
  // Get current user role
  static String? get currentUserRole => _currentUser?['role_type'];
  
  // Clear authentication token and user data
  static void clearAuthToken() {
    _authToken = null;
    _currentUser = null;
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
      print('Using base URL: $baseUrl');
      
      final uri = Uri.parse('$baseUrl/login');
      print('Full URL: $uri');
      
      final requestBody = {
        'email': email,
        'password': password,
      };
      
      print('Request body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      print('Login response status: ${response.statusCode}');
      print('Login response headers: ${response.headers}');
      print('Login response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Save token and user data if present
        if (responseData.containsKey('data') && responseData['data'].containsKey('access_token')) {
          setAuthToken(responseData['data']['access_token']);
          if (responseData['data'].containsKey('user')) {
            setCurrentUser(responseData['data']['user']);
          }
          print('Token saved: ${responseData['data']['access_token']}');
        } else if (responseData.containsKey('token')) {
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
    String roleType = 'client', // Default to client
  }) async {
    try {
      print('Attempting registration for: $email');
      print('Using base URL: $baseUrl');
      
      final uri = Uri.parse('$baseUrl/register'); // Back to real register endpoint
      print('Full URL: $uri');
      
      final requestBody = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role_type': roleType,
      };
      
      print('Request body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      print('Register response status: ${response.statusCode}');
      print('Register response headers: ${response.headers}');
      print('Register response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Save token and user data if present
        if (responseData.containsKey('data') && responseData['data'].containsKey('access_token')) {
          setAuthToken(responseData['data']['access_token']);
          if (responseData['data'].containsKey('user')) {
            setCurrentUser(responseData['data']['user']);
          }
          print('Token saved after registration: ${responseData['data']['access_token']}');
        } else if (responseData.containsKey('token')) {
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
