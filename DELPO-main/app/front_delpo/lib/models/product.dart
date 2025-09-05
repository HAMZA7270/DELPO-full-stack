import 'category.dart';
import 'store.dart';

class Product {
  final int id;
  final int storeId;
  final int categoryId;
  final String name;
  final String? description;
  final double price;
  final double? salePrice;
  final String sku;
  final int stockQuantity;
  final bool trackQuantity;
  final double? weight;
  final String? dimensions;
  final String status;
  final bool isFeatured;
  final Map<String, dynamic>? attributes;
  final String? metaTitle;
  final String? metaDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Store? store;
  final Category? category;
  final List<ProductImage>? images;

  Product({
    required this.id,
    required this.storeId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.salePrice,
    required this.sku,
    required this.stockQuantity,
    this.trackQuantity = true,
    this.weight,
    this.dimensions,
    this.status = 'active',
    this.isFeatured = false,
    this.attributes,
    this.metaTitle,
    this.metaDescription,
    this.createdAt,
    this.updatedAt,
    this.store,
    this.category,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      storeId: json['store_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      salePrice: json['sale_price'] != null 
          ? double.parse(json['sale_price'].toString()) 
          : null,
      sku: json['sku'],
      stockQuantity: json['stock_quantity'],
      trackQuantity: json['track_quantity'] == 1 || json['track_quantity'] == true,
      weight: json['weight'] != null 
          ? double.parse(json['weight'].toString()) 
          : null,
      dimensions: json['dimensions'],
      status: json['status'] ?? 'active',
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      attributes: json['attributes'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      store: json['store'] != null ? Store.fromJson(json['store']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      images: json['images'] != null
          ? (json['images'] as List).map((img) => ProductImage.fromJson(img)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'sale_price': salePrice,
      'sku': sku,
      'stock_quantity': stockQuantity,
      'track_quantity': trackQuantity,
      'weight': weight,
      'dimensions': dimensions,
      'status': status,
      'is_featured': isFeatured,
      'attributes': attributes,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'store': store?.toJson(),
      'category': category?.toJson(),
      'images': images?.map((img) => img.toJson()).toList(),
    };
  }

  // Helper getters
  bool get isActive => status == 'active';
  bool get isInStock => stockQuantity > 0;
  double get finalPrice => salePrice ?? price;
  bool get isOnSale => salePrice != null && salePrice! < price;
  double? get discountPercentage {
    if (!isOnSale) return null;
    return ((price - salePrice!) / price) * 100;
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, sku: $sku}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ProductImage {
  final int id;
  final int productId;
  final String imageUrl;
  final String? altText;
  final int sortOrder;
  final bool isPrimary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductImage({
    required this.id,
    required this.productId,
    required this.imageUrl,
    this.altText,
    this.sortOrder = 0,
    this.isPrimary = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      imageUrl: json['image_url'],
      altText: json['alt_text'],
      sortOrder: json['sort_order'] ?? 0,
      isPrimary: json['is_primary'] == 1 || json['is_primary'] == true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'image_url': imageUrl,
      'alt_text': altText,
      'sort_order': sortOrder,
      'is_primary': isPrimary,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
