
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجر إلكتروني',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange[50],
        fontFamily: 'Tajawal',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/', // الصفحة الرئيسية
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildNotificationContent(context),  // Pass context here
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Notifications'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _clearAllNotifications(context),
        ),
      ],
    );
  }

  Widget _buildNotificationContent(BuildContext context) {  // Accept context
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 5,
      itemBuilder: (context, index) => _buildNotificationItem(context, index),  // Pass context
    );
  }

  Widget _buildNotificationItem(BuildContext context, int index) {  // Accept context
    final notifications = [
      {
        'title': 'New Order Received',
        'message': 'You have a new order #12345',
        'time': '2 min ago',
        'icon': Icons.shopping_bag,
        'read': false
      },
      {
        'title': 'Payment Successful',
        'message': 'Payment for order #12344 has been received',
        'time': '1 hour ago',
        'icon': Icons.payment,
        'read': false
      },
      {
        'title': 'Special Offer',
        'message': '20% discount on all products this weekend',
        'time': '5 hours ago',
        'icon': Icons.local_offer,
        'read': true
      },
      {
        'title': 'Order Shipped',
        'message': 'Your order #12342 has been shipped',
        'time': '1 day ago',
        'icon': Icons.local_shipping,
        'read': true
      },
      {
        'title': 'New Message',
        'message': 'You have a new message from customer',
        'time': '2 days ago',
        'icon': Icons.message,
        'read': true
      },
    ];

    final notification = notifications[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: notification['read'] as bool ? Colors.white : Colors.blue[50],
      child: ListTile(
        leading: Icon(notification['icon'] as IconData,
            color: Theme.of(context).primaryColor),
        title: Text(
          notification['title'] as String,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: notification['read'] as bool ? Colors.grey : Colors.black
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message'] as String),
            const SizedBox(height: 4),
            Text(
              notification['time'] as String,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: notification['read'] as bool
            ? null
            : const CircleAvatar(radius: 4, backgroundColor: Colors.red),
        onTap: () => _handleNotificationTap(context, index),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification ${index + 1} tapped')),
    );
  }

  void _clearAllNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildCartContent(),
    );
  }

  AppBar _buildAppBar(BuildContext context) { // Add context parameter
    return AppBar(
      title: _buildSearchBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 18,
              child: Icon(Icons.person, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return const TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 3, // Replace with actual cart item count
            itemBuilder: (context, index) => _buildCartItem(),
          ),
        ),
        _buildCheckoutSection(),
      ],
    );
  }

  Widget _buildCartItem() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
// Replace with actual product image
              child: const Icon(Icons.image, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('Price: 1,250 د.ج'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () {},
                      ),
                      const Text('1'),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal'),
              Text('3,750 د.ج'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping'),
              Text('250 د.ج'),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('4,000 د.ج', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text('Proceed to Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainContentScreen(),
    const StoresScreen(),
    const MapScreen(),
    const PagesScreen(),
    const PointsProductsScreen(),
// ProfileScreen removed from here since it's in AppBar now
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // Pass context here
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) { // Add context parameter
    return AppBar(
      title: _buildSearchBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShoppingCartPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 18,
              child: Icon(Icons.person, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'ابحث هنا...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'المتاجر'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'الخريطة'),
        BottomNavigationBarItem(icon: Icon(Icons.pages), label: 'الصفحات'),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'النقاط'),
// Removed profile from bottom nav since it's in AppBar now
      ],
    );
  }
}

class MainContentScreen extends StatefulWidget {
  const MainContentScreen({super.key});
  @override
  State<MainContentScreen> createState() => _MainContentScreenState();
}

class _MainContentScreenState extends State<MainContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'المنتجات'),
              Tab(text: 'المحتوى'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(),
                _buildContentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final products = List.generate(6, (index) => 'منتج ${index + 1}');
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailsScreen(productName: products[index])),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.shopping_bag,
                        size: 50, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(products[index], textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentTab() {
    final posts = List.generate(4, (index) => 'محتوى مميز ${index + 1}');
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const Icon(Icons.article, size: 40),
            title: Text(posts[index]),
            subtitle: const Text('وصف مختصر للمحتوى'),
          ),
        );
      },
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final String productName;

  const ProductDetailsScreen({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.shopping_bag,
                  size: 100, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              productName,
              style:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'وصف مفصل للمنتج',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.star, color: Colors.orange, size: 20),
                Text("4.5", style: TextStyle(fontSize: 16)),
                Spacer(),
                Text("100 تقييم",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "السعر: 200 درهم",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('أضف إلى السلة'),
            ),
            const SizedBox(height: 20),
            const Text(
              "الخيارات: الحجم: L, M, S",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}


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
class StoresScreen extends StatelessWidget {
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

// شاشة تفاصيل المتجر

// تأكد من استيراد MapScreen


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

class PagesScreen extends StatelessWidget {
  const PagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصفحات حسب الفئة')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(page['icon'] as IconData),
              title: Text(page['title'] as String),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryItemsScreen(
                      categoryTitle: page['title'] as String,
                      items: page['items'] as List<Map<String, String>>,
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

class CategoryItemsScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Map<String, String>> items;

  const CategoryItemsScreen({
    super.key,
    required this.categoryTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(_getIconForCategory(categoryTitle)),
              title: Text(item['name']!),
              subtitle: Text(item['description']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItemDetailScreen(item: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'مستشفيات':
        return Icons.local_hospital;
      case 'مدارس':
        return Icons.school;
      case 'جامعات':
        return Icons.account_balance;
      case 'مقاهي':
        return Icons.local_cafe;
      case 'مطاعم':
        return Icons.restaurant;
      case 'مكتبات':
        return Icons.book;
      default:
        return Icons.place;
    }
  }
}

class ItemDetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['name']!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.place, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              item['name']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              item['description']!,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.location_on),
              label: const Text('عرض على الخريطة'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخريطة')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.map, size: 100, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('خريطة التطبيق', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('عرض موقعي الحالي'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}


class PointsProductsScreen extends StatelessWidget {
  const PointsProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      {
        'name': 'قسيمة خصم 10%',
        'points': 100,
        'image': Icons.discount,
      },
      {
        'name': 'قسيمة توصيل مجاني',
        'points': 150,
        'image': Icons.local_shipping,
      },
      {
        'name': 'هدية مفاجأة',
        'points': 200,
        'image': Icons.card_giftcard,
      },
      {
        'name': 'قسيمة خصم 20%',
        'points': 250,
        'image': Icons.percent,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('منتجات النقاط')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('النقاط المتاحة:',
                        style: TextStyle(fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('500 نقطة',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(product['image'] as IconData,
                        size: 40, color: Colors.orange),
                    title: Text(product['name'] as String),
                    subtitle: Text('${product['points']} نقطة'),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: const Text('استبدال'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PhotosTab extends StatelessWidget {
  const PhotosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.photo, size: 40, color: Colors.grey),
        );
      },
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('الملف الشخصي'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'المتجر'),
              Tab(text: 'العميل'),
              Tab(text: 'الخدمة'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOriginalStorePage(),
            _buildClientPage(),
            _buildServicePage(),
          ],
        ),
      ),
    );
  }

  Widget _buildOriginalStorePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTopSection(),
          _buildNavigationBar(),
          _buildCurrentContent(),
        ],
      ),
    );
  }
  Widget _buildClientPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
// Welcome Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://example.com/profile.jpg'), // Replace with actual image
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مرحباً بك!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'محمد أحمد',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'mohamed@example.com',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Client Sections
          _buildClientSectionItem('الهدايا', Icons.card_giftcard),
          _buildClientSectionItem('الطلبات', Icons.shopping_bag),
          _buildClientSectionItem('المنتجات المخزنة', Icons.archive),
          _buildClientSectionItem('التقييمات', Icons.star),
          _buildClientSectionItem('المتاجر المفضلة', Icons.favorite),
          _buildClientSectionItem('إعدادات الحساب', Icons.settings),

          const SizedBox(height: 20),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('تسجيل الخروج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Add logout functionality
              },
            ),
          ),
        ],
      ),
    );
  }
// Service Page with Tabs

  Widget _buildServicePage() {
    return DefaultTabController(
      length: 5, // عدد التبويبات أصبح 5 الآن
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تحكم الخدمة'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'الرئيسية'),
              Tab(text: 'نشر'),
              Tab(text: 'الخدمات والعروض'),
              Tab(text: 'فريق العمل'),
              Tab(text: 'التقارير والإحصائيات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildServiceMainPage(),
            _buildPublishPage(), // تبويب "نشر"
            _buildServicesOffersPage(),
            _buildStaffMembersPage(),
            _buildReportsDashboardPage(),
          ],
        ),
      ),
    );
  }

// صفحة "نشر"
  Widget _buildPublishPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الإجراءات السريعة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _buildQuickAction('إضافة خدمة', Icons.add_circle_outline, Colors.blue),
              _buildQuickAction('جدولة موعد', Icons.calendar_month, Colors.green),
              _buildQuickAction('الطلبات', Icons.shopping_basket, Colors.orange),
              _buildQuickAction('العملاء', Icons.group, Colors.teal),
              _buildQuickAction('الإعدادات', Icons.settings, Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

// عنصر الإجراءات السريعة
  Widget _buildQuickAction(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: InkWell(
        onTap: () {
// قم بوضع الإجراء المناسب هنا
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

// 4. Reports Dashboard Page
  Widget _buildReportsDashboardPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
// Summary Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildReportCard('إجمالي الإيرادات', '24,500 د.ج', Icons.attach_money, Colors.green),
              _buildReportCard('الخدمات المقدمة', '156', Icons.handyman, Colors.blue),
              _buildReportCard('العملاء الجدد', '32', Icons.people, Colors.orange),
              _buildReportCard('التقييم العام', '4.8/5', Icons.star, Colors.amber),
            ],
          ),

          const SizedBox(height: 24),

          // Monthly Revenue Chart
          const Text(
            'الإيرادات الشهرية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text('رسم بياني للإيرادات الشهرية سيظهر هنا'),
              // Replace with actual chart widget like charts_flutter
            ),
          ),

          const SizedBox(height: 24),

          // Recent Transactions
          const Text(
            'آخر المعاملات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildTransactionItem('خدمة صيانة', '150 د.ج', '12/05/2023', Colors.green),
                  _buildTransactionItem('تركيب أجهزة', '350 د.ج', '11/05/2023', Colors.blue),
                  _buildTransactionItem('استشارة فنية', '80 د.ج', '10/05/2023', Colors.purple),
                  _buildTransactionItem('إلغاء خدمة', '-150 د.ج', '09/05/2023', Colors.red),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Service Performance
          const Text(
            'أداء الخدمات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text('رسم بياني لأداء الخدمات سيظهر هنا'),
            ),
          ),

          const SizedBox(height: 24),

          // Export Reports Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('تصدير التقارير'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Export reports functionality
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTransactionItem(String service, String amount, String date, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.receipt, color: color),
      ),
      title: Text(service),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
// main is here
// 1. Main Service Page

// Helper widget for contact information rows
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

// Existing helper methods (keep these as they were)

  Widget _buildServiceMainPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
// Hero Banner with Booking Button
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1551434678-e076c223a692?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: const Text('احجز الان', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
// Handle booking
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Service Profile Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'مركز الخدمات المتكاملة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'متخصصون في تقديم أفضل الخدمات',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'نقدم خدمات متكاملة بجودة عالية وبأسعار تنافسية. لدينا فريق من الخبراء المتخصصين في مختلف المجالات لضمان رضا العملاء وتقديم أفضل النتائج.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.location_on, 'العنوان: مدينة الرياض، حي المروج، شارع الملك فهد'),
                  _buildInfoRow(Icons.phone, 'الهاتف: +966 12 345 6789'),
                  _buildInfoRow(Icons.access_time, 'أوقات العمل: 8 صباحاً - 10 مساءً'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Statistics Section
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'إحصائيات الخدمة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.5,
            children: [
              _buildStatItem('الخدمات', '24', Icons.handyman, Colors.blue),
              _buildStatItem('العملاء', '156', Icons.people, Colors.green),
              _buildStatItem('التقييم', '4.9', Icons.star, Colors.amber),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions Panel

        ],
      ),
    );
  }

// Helper Widgets

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

// 2. Services & Offers Page
  Widget _buildServicesOffersPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
// Active Services
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الخدمات المتاحة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                leading: const Icon(Icons.handyman, color: Colors.orange),
                title: Text('خدمة ${index + 1}'),
                subtitle: const Text('وصف مختصر للخدمة'),
                trailing: const Text('150 د.ج'),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Current Offers
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'العروض الحالية',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.local_offer, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        'خصم 20% على جميع الخدمات',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'العرض ساري حتى 30 ديسمبر 2023',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('استخدم العرض'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// 3. Staff Members Page
  Widget _buildStaffMembersPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'فريق العمل',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage('https://example.com/worker.jpg'),
                ),
                title: Text('العامل ${index + 1}'),
                subtitle: const Text('المسمى الوظيفي'),
                trailing: IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {},
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Add New Staff Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('إضافة عضو جديد'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientSectionItem(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
// Add navigation to each section
        },
      ),
    );
  }

// بيانات المنتجات المزيفة
  final List<Map<String, dynamic>> products = [
    {
      'name': 'القنية المتجات',
      'description': 'بالعينة راس بطالس',
      'price': '249DH',
      'image': Icons.shopping_basket,
    },
    {
      'name': 'الرابافة النبات',
      'description': 'الاكترومات السوق السموق',
      'price': '149DH',
      'image': Icons.spa,
    },
    {
      'name': 'تلفاز ذي 55 بوحية',
      'description': 'شاشة ذكية بدقة عالية',
      'price': '3200DH',
      'image': Icons.tv,
    },
    {
      'name': 'سماعات بلوتوث',
      'description': 'جودة صوت عالية',
      'price': '199DH',
      'image': Icons.headset,
    },
  ];

// بيانات الوسائط (صور وفيديوهات)
  final List<Map<String, dynamic>> media = [
    {
      'type': 'image',
      'title': 'عرض خاص',
      'icon': Icons.image,
    },
    {
      'type': 'video',
      'title': 'فيديو توضيحي',
      'icon': Icons.video_library,
    },
    {
      'type': 'image',
      'title': 'منتجات جديدة',
      'icon': Icons.new_releases,
    },
  ];

  Widget _buildCurrentContent() {
    if (_selectedIndex == 0) {
      return _buildHomeContent();
    } else if (_selectedIndex == 1) {
      return _buildNotificationsContent();
    } else if (_selectedIndex == 2) {
      return _buildPublishContent();
    } else {
      return _buildStatisticsContent();
    }
  }

  Widget _buildTopSection() {
    return Column(
      children: [
// Header with store image
        Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://d1csarkz8obe9u.cloudfront.net/posterpreviews/store-banner-design-template-4d06def0b55e3cd5b8fd3b7a828a3612_screen.jpg?ts=1682901383'), // Replace with real URL
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Icon(Icons.store, size: 60, color: Colors.white),
          ),
        ),

        // Store info section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              // Store logo (real image)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('	https://img.freepik.com/vecteurs-libre/modele-logo…sign-plat_23-2149325325.jpg?semt=ais_hybrid&w=740'), // Replace with real URL
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
              ),

              const SizedBox(width: 10),
              const Text(
                'متجرنا',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              // Search field
              SizedBox(
                width: 150,
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildNavigationBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'الرئيسية', 0),
          _buildNavItem(Icons.notifications, 'الإشعارات', 1),
          _buildNavItem(Icons.add_circle, 'النشر', 2),
          _buildNavItem(Icons.analytics, 'الإحصائيات', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Colors.orange : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length + media.length,
            itemBuilder: (context, index) {
              if (index < products.length) {
                final product = products[index];
                return _buildProductItem(product);
              } else {
                final medium = media[index - products.length];
                return _buildMediaItem(medium);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Icon(
                product['image'] as IconData,
                size: 50,
                color: Colors.orange[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['description'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product['price'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaItem(Map<String, dynamic> medium) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            medium['icon'] as IconData,
            size: 50,
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          Text(
            medium['title'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            medium['type'] == 'image' ? 'صورة' : 'فيديو',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNotificationItem('طلب جديد', 'لديك طلب جديد من العميل محمد'),
          _buildNotificationItem('متابع جديد', 'علي قام بمتابعة متجرك'),
          _buildNotificationItem('تفاعل', 'احمد أعجب بمنتجك'),
          _buildNotificationItem('طلب جديد', 'لديك طلب جديد من العميل خالد'),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title: Text(title),
        subtitle: Text(message),
        trailing: const Text('اليوم'),
      ),
    );
  }


  Widget _buildPublishContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'اختر طريقة النشر',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildPublishOption('عرض منتج', Icons.shopping_bag),
          const SizedBox(height: 15),
          _buildPublishOption('عرض إعلان', Icons.campaign),
        ],
      ),
    );
  }

  Widget _buildPublishOption(String title, IconData icon) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.orange),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {},
      ),
    );
  }

  Widget _buildStatisticsContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatCard('إجمالي المبيعات', '1,250 د.ج', Icons.attach_money),
          _buildStatCard('عدد الزيارات', '3,450', Icons.remove_red_eye),
          _buildStatCard('عدد الطلبات', '45', Icons.shopping_cart),
          _buildStatCard('المتابعون', '1,230', Icons.people),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.orange),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(
                  value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

