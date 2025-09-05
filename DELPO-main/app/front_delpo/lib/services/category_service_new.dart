import '../models/category.dart';
import 'api_service.dart';

class CategoryService {
  // Get all categories with fallback data
  static Future<List<Category>> getAllCategories() async {
    try {
      final response = await ApiService.get('/categories');
      final List<dynamic> categoriesJson = response['data'] ?? response['categories'] ?? [];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error loading categories from API: $e');
      // Return mock data for testing
      return _getMockCategories();
    }
  }

  // Get active categories only
  static Future<List<Category>> getActiveCategories() async {
    try {
      final response = await ApiService.get('/categories?active=1');
      final List<dynamic> categoriesJson = response['data'] ?? response['categories'] ?? [];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error loading active categories: $e');
      return _getMockCategories();
    }
  }

  // Get category by ID
  static Future<Category> getCategoryById(int id) async {
    try {
      final response = await ApiService.get('/categories/$id');
      return Category.fromJson(response['data'] ?? response);
    } catch (e) {
      print('Error loading category $id: $e');
      rethrow;
    }
  }

  // Get main categories (parent categories)
  static Future<List<Category>> getMainCategories() async {
    try {
      final response = await ApiService.get('/categories?parent=null');
      final List<dynamic> categoriesJson = response['data'] ?? response['categories'] ?? [];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error loading main categories: $e');
      return _getMockCategories();
    }
  }

  // Mock data for testing when API is not available
  static List<Category> _getMockCategories() {
    return [
      Category(
        id: 1,
        name: 'الإلكترونيات',
        slug: 'electronics',
        description: 'أجهزة إلكترونية متنوعة',
        iconUrl: null,
        colorCode: '#FF5722',
        sortOrder: 1,
        parentId: null,
        isActive: true,
      ),
      Category(
        id: 2,
        name: 'الملابس',
        slug: 'clothing',
        description: 'ملابس رجالية ونسائية',
        iconUrl: null,
        colorCode: '#2196F3',
        sortOrder: 2,
        parentId: null,
        isActive: true,
      ),
      Category(
        id: 3,
        name: 'المنزل والحديقة',
        slug: 'home-garden',
        description: 'مستلزمات المنزل والحديقة',
        iconUrl: null,
        colorCode: '#4CAF50',
        sortOrder: 3,
        parentId: null,
        isActive: true,
      ),
    ];
  }
}
