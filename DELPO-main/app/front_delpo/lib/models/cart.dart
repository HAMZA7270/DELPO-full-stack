import 'product.dart';

class Cart {
  final int id;
  final int? userId;
  final String? sessionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CartItem>? items;

  Cart({
    required this.id,
    this.userId,
    this.sessionId,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user_id'],
      sessionId: json['session_id'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      items: json['items'] != null
          ? (json['items'] as List).map((item) => CartItem.fromJson(item)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'session_id': sessionId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }

  // Calculate total price
  double get totalPrice {
    if (items == null) return 0.0;
    return items!.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Calculate total items count
  int get totalItems {
    if (items == null) return 0;
    return items!.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartItem {
  final int id;
  final int cartId;
  final int productId;
  final int quantity;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Product? product;

  CartItem({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      cartId: json['cart_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      product: json['product'] != null 
          ? Product.fromJson(json['product']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'product': product?.toJson(),
    };
  }

  // Calculate total price for this item
  double get totalPrice => price * quantity;
}
