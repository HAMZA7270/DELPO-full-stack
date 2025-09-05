class ApiConstants {
  // Base API URL - make sure this matches your Laravel API server
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // API version
  static const String apiVersion = 'v1';
  
  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  
  // Categories
  static const String categories = '/categories';
  
  // Products
  static const String products = '/products';
  
  // Stores
  static const String stores = '/stores';
  
  // Cart
  static const String cart = '/cart';
  
  // Orders
  static const String orders = '/orders';
  
  // Wishlist
  static const String wishlist = '/wishlist';
  
  // Delivery
  static const String delivery = '/delivery';
}

class AppConstants {
  static const String appName = 'DELPO';
  static const String appVersion = '1.0.0';
  
  // Shared preferences keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';
}
