import 'package:flutter/material.dart';


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

