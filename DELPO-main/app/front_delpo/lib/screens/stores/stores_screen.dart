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
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  List<Category> _categories = [];
  List<Store> _stores = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load categories and stores in parallel
      final results = await Future.wait([
        CategoryService.getActiveCategories(),
        StoreService.getAllStores(),
      ]);

      setState(() {
        _categories = results[0] as List<Category>;
        _stores = results[1] as List<Store>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل في تحميل البيانات: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتاجر حسب الفئة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Text('لا توجد فئات متاحة'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final categoryStores = _stores.where((store) => store.categoryId == category.id).toList();
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _parseColor(category.colorCode),
              child: Icon(
                _getCategoryIcon(category.slug),
                color: Colors.white,
              ),
            ),
            title: Text(category.name),
            subtitle: Text('${categoryStores.length} متجر'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryStoresScreen(
                    category: category,
                    stores: categoryStores,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _parseColor(String? colorCode) {
    if (colorCode == null || !colorCode.startsWith('#')) {
      return Colors.blue;
    }
    return Color(int.parse(colorCode.substring(1), radix: 16) + 0xFF000000);
  }

  IconData _getCategoryIcon(String slug) {
    switch (slug) {
      case 'electronics':
        return Icons.phone_android;
      case 'clothing':
        return Icons.checkroom;
      case 'food-beverages':
        return Icons.restaurant;
      default:
        return Icons.store;
    }
  }
}

// شاشة عرض المتاجر حسب الفئة
class CategoryStoresScreen extends StatelessWidget {
  final Category category;
  final List<Store> stores;

  const CategoryStoresScreen({
    super.key,
    required this.category,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('متاجر ${category.name}')),
      body: stores.isEmpty
          ? const Center(child: Text('لا توجد متاجر في هذه الفئة'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: store.logoImageUrl != null
                          ? NetworkImage(store.logoImageUrl!)
                          : null,
                      child: store.logoImageUrl == null
                          ? Icon(Icons.store)
                          : null,
                    ),
                    title: Text(store.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(store.description ?? 'متجر رائع'),
                        Text('${store.areaName} • ${store.operationalStatus == 'open' ? 'مفتوح' : 'مغلق'}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
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

class StoreDetailScreen extends StatefulWidget {
  final Store store;

  const StoreDetailScreen({super.key, required this.store});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'All';
  final List<Product> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  Future<void> _loadStoreData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load store products and categories
      final results = await Future.wait([
        StoreService.getStoreProducts(widget.store.id),
        CategoryService.getActiveCategories(),
      ]);

      setState(() {
        _products = results[0] as List<Product>;
        _categories = results[1] as List<Category>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'فشل في تحميل المنتجات: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') return _products;
    return _products.where((product) {
      final category = _categories.firstWhere(
        (cat) => cat.id == product.categoryId,
        orElse: () => Category(id: 0, name: '', slug: ''),
      );
      return category.name == _selectedCategory;
    }).toList();
  }

  void _addToCart(Product product) {
    setState(() {
      _cartItems.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${product.name} إلى السلة'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeName = widget.store.name;
    final bannerUrl = widget.store.backgroundImageUrl ?? 'https://via.placeholder.com/400x200?text=Store+Banner';
    final storeLogo = widget.store.logoImageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to cart
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(storeName, bannerUrl, storeLogo),
    );
  }

  Widget _buildBody(String storeName, String bannerUrl, String? storeLogo) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadStoreData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Store Header
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
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
                            image: NetworkImage(storeLogo),
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
              children: ['All', ..._categories.map((c) => c.name)].map((category) {
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
          if (_filteredProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('لا توجد منتجات في هذه الفئة'),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return _buildProductCard(product);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/150?text=${Uri.encodeComponent(product.name)}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.finalPrice.toStringAsFixed(2)} ر.س',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: product.isInStock ? () => _addToCart(product) : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      product.isInStock ? 'أضف للسلة' : 'غير متوفر',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
