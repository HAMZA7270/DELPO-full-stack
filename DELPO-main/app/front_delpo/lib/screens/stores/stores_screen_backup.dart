import 'package:flutter/material.dart';
import '../map/map_screen.dart';

// بيانات الفئات والمتاجر
final categories = [
  {
    'title': 'خضروات وفواكه',
    'icon': Icons.local_grocery_store,
    'stores': [
      {'name': 'متجر الخضر 1', 'description': 'أفضل خضر طازجة يوميًا'},
      {'name': 'متجر الخضر 2', 'description': 'منتجات موسمية ومحلية'},
    ],
  },
  {
    'title': 'أزياء وموضة',
    'icon': Icons.checkroom,
    'stores': [
      {'name': 'متجر الأزياء 1', 'description': 'ملابس رجالية ونسائية'},
      {'name': 'متجر الأزياء 2', 'description': 'أحدث صيحات الموضة'},
    ],
  },
  {
    'title': 'صيدليات',
    'icon': Icons.medical_services,
    'stores': [
      {'name': 'صيدلية النجاح', 'description': 'أدوية أصلية وخدمة سريعة'},
      {'name': 'صيدلية الشفاء', 'description': 'توصيل مجاني داخل المدينة'},
    ],
  },
];

// شاشة الفئات
import 'package:flutter/material.dart';
import '../../models/store.dart';
import '../../models/product.dart';
import '../../models/category.dart';
import '../../services/store_service.dart';
import '../../services/product_service.dart';
import '../../services/category_service.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المتاجر حسب الفئة')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(category['icon'] as IconData),
              title: Text(category['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryStoresScreen(
                      categoryTitle: category['title'] as String,
                      stores: category['stores'] as List<Map<String, String>>,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// شاشة عرض المتاجر حسب الفئة
class CategoryStoresScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Map<String, String>> stores;

  const CategoryStoresScreen({
    super.key,
    required this.categoryTitle,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('متاجر $categoryTitle')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final store = stores[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.store),
              title: Text(store['name']!),
              subtitle: Text(store['description']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoreDetailScreen(store: store),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


List<Map<String, dynamic>> stores = [
  {
    'name': 'مطعم النخلة',
    'image': 'https://via.placeholder.com/400x200',
    'rating': 4.5,
    'city': 'الرياض',
    'products': [
      {
        'name': 'بيتزا مارغريتا',
        'price': 40.0,
        'image': 'https://via.placeholder.com/150?text=بيتزا',
      },
      {
        'name': 'برغر مزدوج',
        'price': 28.0,
        'image': 'https://via.placeholder.com/150?text=برغر',
      },
    ]
  },
// المزيد من المتاجر ...
];


// Mock MapScreen for demonstration

class StoreDetailScreen extends StatefulWidget {
  final Map<String, dynamic> store;

  const StoreDetailScreen({super.key, required this.store});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  final List<Map<String, dynamic>> _cartItems = [];
  String _selectedCategory = 'All';

// Sample products for different categories
  final List<Map<String, dynamic>> _allProducts = [
// Vegetables
    {
      "name": "Organic Tomatoes",
      "price": 3.99,
      "image": "https://images.unsplash.com/photo-1594282408481-2a1a468b29e8",
      "category": "Vegetables",
      "description": "Fresh organic tomatoes",
      "rating": 4.5
    },
    {
      "name": "Carrots",
      "price": 2.49,
      "image": "https://images.unsplash.com/photo-1447175008436-054170c2e979",
      "category": "Vegetables",
      "description": "Sweet fresh carrots",
      "rating": 4.2
    },
// Clothes
    {
      "name": "Cotton T-Shirt",
      "price": 19.99,
      "image": "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab",
      "category": "Clothes",
      "description": "100% cotton white t-shirt",
      "rating": 4.3
    },
    {
      "name": "Denim Jeans",
      "price": 49.99,
      "image": "https://images.unsplash.com/photo-1542272604-787c3835535d",
      "category": "Clothes",
      "description": "Classic blue jeans",
      "rating": 4.7
    },
// Add more products as needed...
  ];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeName = widget.store['name']?.toString() ?? 'Our Store';
    final storeLogo = widget.store['logo'];
    const bannerUrl = 'https://www.shutterstock.com/image-vector/farm-fresh-vegetables-vector-banner-260nw-1441702031.jpg';

    // Filter products by selected category
    final displayedProducts = _selectedCategory == 'All'
        ? _allProducts
        : _allProducts.where((p) => p['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Cart functionality
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      _cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Store Header with vegetable banner
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(bannerUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0, 40, 0),
                  child: Column(
                    children: [
                      if (storeLogo != null)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              image: NetworkImage(storeLogo.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          storeName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Category Filter Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['All', 'Vegetables', 'Clothes'].map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: _selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product Image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product['image'].toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        ),
                        // Product Details
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              _buildRatingStars(product['rating']),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () => _addToCart(product),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Add to Cart'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Location Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapScreen()),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('View Store Location'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
final pages = [
  {
    'title': 'مستشفيات',
    'icon': Icons.local_hospital,
    'items': [
      {'name': 'مستشفى المدينة', 'description': 'مستشفى عام متكامل الخدمات'},
      {'name': 'مستشفى التخصصي', 'description': 'أفضل الأطباء المتخصصين'},
    ],
  },
  {
    'title': 'مدارس',
    'icon': Icons.school,
    'items': [
      {'name': 'مدرسة النجاح', 'description': 'تعليم أساسي وثانوي'},
      {'name': 'مدرسة الأوائل', 'description': 'منهج متقدم ونتائج متميزة'},
    ],
  },
  {
    'title': 'جامعات',
    'icon': Icons.account_balance,
    'items': [
      {'name': 'جامعة المدينة', 'description': 'أكبر جامعة في المنطقة'},
      {'name': 'الجامعة التقنية', 'description': 'تخصصات هندسية وعلمية'},
    ],
  },
  {
    'title': 'مقاهي',
    'icon': Icons.local_cafe,
    'items': [
      {'name': 'مقهى الرواق', 'description': 'أجواء هادئة للعمل والقراءة'},
      {'name': 'مقهى الأصيل', 'description': 'أفضل أنواع القهوة المحلية'},
    ],
  },
  {
    'title': 'مطاعم',
    'icon': Icons.restaurant,
    'items': [
      {'name': 'مطعم الشرق', 'description': 'أطباق شرقية متنوعة'},
      {'name': 'مطعم البحار', 'description': 'مأكولات بحرية طازجة'},
    ],
  },
  {
    'title': 'مكتبات',
    'icon': Icons.book,
    'items': [
      {'name': 'مكتبة المعرفة', 'description': 'أكبر تشكيلة كتب عربية وأجنبية'},
      {'name': 'مكتبة الطالب', 'description': 'كتب ومراجع دراسية'},
    ],
  },
];
