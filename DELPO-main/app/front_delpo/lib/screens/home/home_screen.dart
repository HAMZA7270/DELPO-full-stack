import 'package:flutter/material.dart';
import '../notification/notification_page.dart';
import '../cart/cart_page.dart';
import '../profile/role_based_profile_screen.dart';
import '../stores/stores_screen.dart';
import '../map/map_screen.dart';
import '../pages/pages_screen.dart';
import '../points/points_screen.dart';
import '../pages/item_detail_screen.dart';
import '../../services/auth_service.dart';
// Removed duplicate import since stores_screen.dart is already imported above

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
        // عرض أزرار مشروطة بناءً على حالة التسجيل
        ..._buildAuthButtons(context),
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
              MaterialPageRoute(builder: (context) => const RoleBasedProfileScreen()),
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

  // أزرار مشروطة بناءً على حالة التسجيل
  List<Widget> _buildAuthButtons(BuildContext context) {
    bool isAuthenticated = AuthService.isAuthenticated();
    
    print('Building auth buttons, isAuthenticated: $isAuthenticated'); // Debug line
    
    if (isAuthenticated) {
      // المستخدم مسجل الدخول - لا تعرض أي أزرار هنا، الخروج متاح في صفحة الملف الشخصي
      return [];
    } else {
      // المستخدم غير مسجل الدخول - عرض أزرار تسجيل الدخول والتسجيل
      return [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.login, color: Colors.blue, size: 24),
            tooltip: 'تسجيل الدخول',
            onPressed: () async {
              print('Login button pressed'); // Debug line
              final result = await Navigator.pushNamed(context, '/login');
              if (result == true) {
                // تحديث الشاشة بعد تسجيل الدخول الناجح
                setState(() {});
              }
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.person_add, color: Colors.green, size: 24),
            tooltip: 'إنشاء حساب',
            onPressed: () async {
              print('Register button pressed'); // Debug line
              final result = await Navigator.pushNamed(context, '/register');
              if (result == true) {
                // تحديث الشاشة بعد التسجيل الناجح
                setState(() {});
              }
            },
          ),
        ),
      ];
    }
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


