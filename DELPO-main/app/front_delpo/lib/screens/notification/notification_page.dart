import 'package:flutter/material.dart';

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
