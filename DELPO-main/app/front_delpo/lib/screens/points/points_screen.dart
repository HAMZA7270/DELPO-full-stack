import 'package:flutter/material.dart';

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
