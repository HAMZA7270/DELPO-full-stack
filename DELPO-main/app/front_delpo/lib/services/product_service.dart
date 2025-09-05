import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  // Get all products with fallback data
  static Future<List<Product>> getAllProducts({int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/products?page=$page&per_page=$perPage');
      // Handle Laravel paginated response structure
      final List<dynamic> productsJson = response['data']['data'] ?? response['data'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products from API: $e');
      // Return mock data for testing
      return _getMockProducts();
    }
  }

  // Get product by ID
  static Future<Product> getProductById(int id) async {
    try {
      final response = await ApiService.get('/products/$id');
      return Product.fromJson(response['data'] ?? response);
    } catch (e) {
      print('Error loading product $id: $e');
      rethrow;
    }
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(int categoryId, {int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/categories/$categoryId/products?page=$page&per_page=$perPage');
      final List<dynamic> productsJson = response['data'] ?? response['products'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products for category $categoryId: $e');
      return _getMockProducts();
    }
  }

  // Get products by store
  static Future<List<Product>> getProductsByStore(int storeId, {int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/stores/$storeId/products?page=$page&per_page=$perPage');
      final List<dynamic> productsJson = response['data'] ?? response['products'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error loading products for store $storeId: $e');
      return _getMockProducts();
    }
  }

  // Search products
  static Future<List<Product>> searchProducts(String query, {int page = 1, int perPage = 10}) async {
    try {
      final response = await ApiService.get('/products/search?q=$query');
      final List<dynamic> productsJson = response['data'] ?? response['products'] ?? [];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error searching products: $e');
      return _getMockProducts();
    }
  }

  // Mock data for testing when API is not available
  static List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: 'منتج تجريبي 1',
        description: 'وصف المنتج التجريبي الأول',
        price: 29.99,
        stockQuantity: 100,
        sku: 'TEST001',
        isActive: true,
        categoryId: 1,
        storeId: 1,
      ),
      Product(
        id: 2,
        name: 'منتج تجريبي 2',
        description: 'وصف المنتج التجريبي الثاني',
        price: 49.99,
        stockQuantity: 50,
        sku: 'TEST002',
        isActive: true,
        categoryId: 1,
        storeId: 1,
      ),
      Product(
        id: 3,
        name: 'منتج تجريبي 3',
        description: 'وصف المنتج التجريبي الثالث',
        price: 19.99,
        stockQuantity: 200,
        sku: 'TEST003',
        isActive: true,
        categoryId: 2,
        storeId: 1,
      ),
    ];
  }
}
