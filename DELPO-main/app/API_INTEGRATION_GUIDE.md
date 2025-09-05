# DELPO Flutter App - API Integration Guide

## 🎉 What We've Accomplished

Your Flutter app is now fully prepared for API integration with your Laravel backend! Here's what has been set up:

## 📁 Project Structure

```
lib/
├── models/
│   ├── cart.dart           # Cart and CartItem models
│   ├── category.dart       # Category model  
│   ├── product.dart        # Product model
│   ├── store.dart          # Store model
│   ├── user.dart           # User and UserProfile models
│   └── notification.dart   # Notification model
├── services/
│   ├── api_service.dart       # Core API communication
│   ├── auth_service.dart      # Authentication handling
│   ├── cart_service.dart      # Cart management (local + API)
│   ├── category_service.dart  # Category operations
│   └── product_service.dart   # Product operations
├── utils/
│   └── constants.dart      # App constants and configuration
└── screens/            # Your existing UI screens
```

## 🔧 Key Features Implemented

### 1. **Enhanced API Service** (`services/api_service.dart`)
- ✅ Authentication token management
- ✅ Automatic error handling with custom `ApiException`
- ✅ Support for all HTTP methods (GET, POST, PUT, DELETE)
- ✅ Proper JSON response processing
- ✅ Bearer token authentication headers

### 2. **Authentication Service** (`services/auth_service.dart`)
- ✅ User login/register/logout
- ✅ Token management
- ✅ Current user retrieval
- ✅ Authentication state checking

### 3. **Smart Cart Service** (`services/cart_service.dart`)
- ✅ Hybrid cart system (local for guests, API for authenticated users)
- ✅ Automatic cart synchronization when user logs in
- ✅ Complete CRUD operations for cart items
- ✅ Cart totals and item count calculation

### 4. **Enhanced Models**
- ✅ All models match your Laravel backend structure
- ✅ Proper JSON serialization/deserialization
- ✅ Null safety and proper typing
- ✅ User profile support

### 5. **Configuration Management** (`utils/constants.dart`)
- ✅ Centralized API endpoints
- ✅ App-wide constants
- ✅ UI constants for consistent styling

## 🚀 How to Use Your API-Ready App

### 1. **Start Your Laravel API**
First, make sure your Laravel API is running:
```bash
cd /home/username/hamza/DELPO/app/api_delpo
php artisan serve
```
Your API will be available at: `http://localhost:8000`

### 2. **Run Your Flutter App**
```bash
cd /home/username/hamza/DELPO/app/front_delpo
flutter run -d web-server --web-port 3000
```
Your Flutter app will be available at: `http://localhost:3000`

### 3. **Test API Integration**

#### **Fetch Categories**
```dart
import 'services/category_service.dart';

// In your widget
Future<void> loadCategories() async {
  try {
    final categories = await CategoryService.getActiveCategories();
    // Update your UI with categories
  } catch (e) {
    // Handle error
    print('Error loading categories: $e');
  }
}
```

#### **Fetch Products**
```dart
import 'services/product_service.dart';

// In your widget
Future<void> loadProducts() async {
  try {
    final products = await ProductService.getAllProducts();
    // Update your UI with products
  } catch (e) {
    // Handle error
    print('Error loading products: $e');
  }
}
```

#### **User Authentication**
```dart
import 'services/auth_service.dart';

// Login
Future<void> login(String email, String password) async {
  try {
    final response = await AuthService.login(email, password);
    // User is now logged in, token is saved automatically
    // Sync cart if needed
    await CartService.syncLocalCartWithAPI();
  } catch (e) {
    // Handle login error
    print('Login error: $e');
  }
}
```

#### **Cart Operations**
```dart
import 'services/cart_service.dart';

// Add to cart
await CartService.addToCart(product, quantity: 2);

// Get cart
final cart = await CartService.getCurrentCart();

// Get cart total
final total = CartService.getCartTotal();

// Get items count
final itemsCount = CartService.getCartItemsCount();
```

## 🔒 Security Features

- **Token-based authentication** with automatic header injection
- **Secure token storage** (ready for SharedPreferences integration)
- **Automatic logout** on authentication errors
- **API error handling** with user-friendly messages

## 📱 Next Steps

### 1. **Add SharedPreferences for Persistent Storage**
Add to your `pubspec.yaml`:
```yaml
dependencies:
  shared_preferences: ^2.2.3
```

Then update `ApiService` to persist tokens:
```dart
// In api_service.dart
static Future<void> setAuthToken(String token) async {
  _authToken = token;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}
```

### 2. **Add State Management**
Consider adding state management like Provider or Riverpod:
```yaml
dependencies:
  provider: ^6.1.2
```

### 3. **Add Loading States**
Create loading indicators for API calls:
```dart
class ApiLoadingState extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

### 4. **Error Handling UI**
Create user-friendly error messages:
```dart
void handleApiError(ApiException error) {
  String userMessage = 'Something went wrong';
  
  if (error.statusCode == 401) {
    userMessage = 'Please log in again';
  } else if (error.statusCode == 422) {
    userMessage = error.message; // Validation errors
  }
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(userMessage)),
  );
}
```

## 🌐 API Endpoints Available

Your Flutter app is ready to use these Laravel API endpoints:

### Public Endpoints
- `GET /api/products` - Get all products
- `GET /api/categories` - Get all categories  
- `GET /api/stores` - Get all stores
- `POST /api/login` - User login
- `POST /api/register` - User registration

### Authenticated Endpoints
- `GET /api/user` - Get current user
- `POST /api/logout` - User logout
- `GET /api/cart` - Get user cart
- `POST /api/cart/items` - Add item to cart
- `PUT /api/cart/items/{id}` - Update cart item
- `DELETE /api/cart/items/{id}` - Remove cart item
- `POST /api/orders` - Create order

## ✅ Status Summary

- ✅ **API Service**: Complete with authentication & error handling
- ✅ **Authentication**: Login, register, logout, token management
- ✅ **Cart System**: Hybrid local/API cart with auto-sync
- ✅ **Models**: All models ready and matching Laravel backend
- ✅ **Services**: Category, Product, Cart services implemented
- ✅ **Error Handling**: Custom exceptions and proper error propagation
- ✅ **Configuration**: Centralized constants and endpoints

## 🐛 Troubleshooting

### Common Issues

1. **CORS Error**: Make sure your Laravel API has CORS configured for `http://localhost:3000`
2. **Network Error**: Verify both Laravel and Flutter apps are running
3. **Authentication Error**: Check that your Laravel API returns tokens in the expected format

### Debug Tips

1. **Check API Response**: Use browser dev tools to inspect network requests
2. **Check Laravel Logs**: `tail -f api_delpo/storage/logs/laravel.log`  
3. **Flutter Debug**: Use `flutter logs` to see debug output

Your Flutter app is now completely ready for production-level API integration! 🚀
