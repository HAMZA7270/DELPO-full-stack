import '../models/store.dart';
import '../models/product.dart';
import 'api_service.dart';

class StoreService {
  // Get all stores
  static Future<List<Store>> getAllStores({int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/stores?page=$page&per_page=$perPage');
      // Handle both paginated and non-paginated responses
      final List<dynamic> storesJson = response['data']['data'] ?? response['data'] ?? [];
      return storesJson.map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error loading stores from API: $e');
      return _getMockStores();
    }
  }

  // Get store by ID
  static Future<Store> getStoreById(int id) async {
    try {
      final response = await ApiService.get('/stores/$id');
      return Store.fromJson(response['data'] ?? response);
    } catch (e) {
      print('Error loading store $id: $e');
      rethrow;
    }
  }

  // Get stores by category
  static Future<List<Store>> getStoresByCategory(int categoryId, {int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/categories/$categoryId/stores?page=$page&per_page=$perPage');
      final List<dynamic> storesJson = response['data'] ?? response['stores'] ?? [];
      return storesJson.map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error loading stores for category $categoryId: $e');
      return _getMockStores();
    }
  }

  // Get products for a specific store
  static Future<List<Product>> getStoreProducts(int storeId, {int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/stores/$storeId/products?page=$page&per_page=$perPage');
      final List<dynamic> productsJson = response['data']['data'] ?? response['data'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products for store $storeId: $e');
      return [];
    }
  }

  // Search stores
  static Future<List<Store>> searchStores(String query, {int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/stores/search?q=$query&page=$page&per_page=$perPage');
      final List<dynamic> storesJson = response['data'] ?? response['stores'] ?? [];
      return storesJson.map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error searching stores: $e');
      return _getMockStores();
    }
  }

  // Get nearby stores (if geolocation is available)
  static Future<List<Store>> getNearbyStores(double latitude, double longitude, {double radius = 10, int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/stores/nearby?lat=$latitude&lng=$longitude&radius=$radius&page=$page&per_page=$perPage');
      final List<dynamic> storesJson = response['data'] ?? response['stores'] ?? [];
      return storesJson.map((json) => Store.fromJson(json)).toList();
    } catch (e) {
      print('Error loading nearby stores: $e');
      return _getMockStores();
    }
  }

  // Mock data for testing when API is not available
  static List<Store> _getMockStores() {
    return [
      Store(
        id: 1,
        name: 'متجر تجريبي',
        userId: 1,
        areaName: 'الرياض',
        phoneNumber: '+966501234567',
        emailAddress: 'test@store.com',
        categoryId: 1,
        streetAddress: 'الرياض، المملكة العربية السعودية',
        description: 'متجر للاختبار',
        operationalStatus: 'open',
        isActive: true,
      ),
    ];
  }
}
