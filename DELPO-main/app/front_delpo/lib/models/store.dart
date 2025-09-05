import 'category.dart';

class Store {
  final int id;
  final String name;
  final int userId;
  final String areaName;
  final String phoneNumber;
  final String emailAddress;
  final int categoryId;
  final String? logoImageUrl;
  final String? backgroundImageUrl;
  final List<String>? storePhotosUrls;
  final List<String>? staffPhotosUrls;
  final double? latitudeCoordinate;
  final double? longitudeCoordinate;
  final String streetAddress;
  final String? description;
  final String operationalStatus;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Category? category;

  Store({
    required this.id,
    required this.name,
    required this.userId,
    required this.areaName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.categoryId,
    this.logoImageUrl,
    this.backgroundImageUrl,
    this.storePhotosUrls,
    this.staffPhotosUrls,
    this.latitudeCoordinate,
    this.longitudeCoordinate,
    required this.streetAddress,
    this.description,
    this.operationalStatus = 'open',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      areaName: json['area_name'],
      phoneNumber: json['phone_number'],
      emailAddress: json['email_address'],
      categoryId: json['category_id'],
      logoImageUrl: json['logo_image_url'],
      backgroundImageUrl: json['background_image_url'],
      storePhotosUrls: json['store_photos_urls'] != null
          ? List<String>.from(json['store_photos_urls'])
          : null,
      staffPhotosUrls: json['staff_photos_urls'] != null
          ? List<String>.from(json['staff_photos_urls'])
          : null,
      latitudeCoordinate: json['latitude_coordinate'] != null
          ? double.parse(json['latitude_coordinate'].toString())
          : null,
      longitudeCoordinate: json['longitude_coordinate'] != null
          ? double.parse(json['longitude_coordinate'].toString())
          : null,
      streetAddress: json['street_address'],
      description: json['description'],
      operationalStatus: json['operational_status'] ?? 'open',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'area_name': areaName,
      'phone_number': phoneNumber,
      'email_address': emailAddress,
      'category_id': categoryId,
      'logo_image_url': logoImageUrl,
      'background_image_url': backgroundImageUrl,
      'store_photos_urls': storePhotosUrls,
      'staff_photos_urls': staffPhotosUrls,
      'latitude_coordinate': latitudeCoordinate,
      'longitude_coordinate': longitudeCoordinate,
      'street_address': streetAddress,
      'description': description,
      'operational_status': operationalStatus,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category': category?.toJson(),
    };
  }

  // Helper getters
  bool get isOpen => operationalStatus == 'open';
  bool get isClosed => operationalStatus == 'closed';
  bool get isTemporarilyClosed => operationalStatus == 'temporarily_closed';

  @override
  String toString() {
    return 'Store{id: $id, name: $name, areaName: $areaName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
