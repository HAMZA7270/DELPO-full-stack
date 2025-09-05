class Category {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? iconUrl;
  final String? colorCode;
  final int? sortOrder;
  final int? parentId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.iconUrl,
    this.colorCode,
    this.sortOrder,
    this.parentId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      iconUrl: json['icon_url'],
      colorCode: json['color_code'],
      sortOrder: json['sort_order'],
      parentId: json['parent_id'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
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
      'name': name,
      'slug': slug,
      'description': description,
      'icon_url': iconUrl,
      'color_code': colorCode,
      'sort_order': sortOrder,
      'parent_id': parentId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, slug: $slug}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
