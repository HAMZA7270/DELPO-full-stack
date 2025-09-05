import 'package:flutter/material.dart';
import '../notification/notification_page.dart';
import '../profile/profile_screen.dart';


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
