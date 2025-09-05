import 'package:flutter/material.dart';
import '../map/map_screen.dart';


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
