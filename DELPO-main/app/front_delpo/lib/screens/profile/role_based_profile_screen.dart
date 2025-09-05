import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RoleBasedProfileScreen extends StatefulWidget {
  const RoleBasedProfileScreen({super.key});

  @override
  State<RoleBasedProfileScreen> createState() => _RoleBasedProfileScreenState();
}

class _RoleBasedProfileScreenState extends State<RoleBasedProfileScreen> {
  
  // Get role-specific content
  Widget _getRoleBasedContent() {
    final userRole = AuthService.currentUserRole;
    final user = AuthService.currentUser;
    
    switch (userRole) {
      case 'client':
        return _buildClientProfile(user);
      case 'store_owner':
        return _buildStoreOwnerProfile(user);
      case 'service_provider':
        return _buildServiceProviderProfile(user);
      default:
        return _buildDefaultProfile(user);
    }
  }

  // Get role-specific title
  String _getRoleTitle() {
    final userRole = AuthService.currentUserRole;
    switch (userRole) {
      case 'client':
        return 'ملف العميل';
      case 'store_owner':
        return 'ملف صاحب المتجر';
      case 'service_provider':
        return 'ملف مقدم الخدمة';
      default:
        return 'الملف الشخصي';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_getRoleTitle()),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await AuthService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _getRoleBasedContent(),
    );
  }

  // Client Profile Content
  Widget _buildClientProfile(Map<String, dynamic>? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          _buildUserInfoCard(user),
          const SizedBox(height: 16),
          
          // Client-specific features
          _buildSectionTitle('خدمات العميل'),
          const SizedBox(height: 8),
          _buildClientFeatures(),
          const SizedBox(height: 24),
          
          // Recent Orders
          _buildSectionTitle('الطلبات الأخيرة'),
          const SizedBox(height: 8),
          _buildRecentOrders(),
          const SizedBox(height: 24),
          
          // Wishlist
          _buildSectionTitle('قائمة الرغبات'),
          const SizedBox(height: 8),
          _buildWishlist(),
        ],
      ),
    );
  }

  // Store Owner Profile Content
  Widget _buildStoreOwnerProfile(Map<String, dynamic>? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          _buildUserInfoCard(user),
          const SizedBox(height: 16),
          
          // Store Management
          _buildSectionTitle('إدارة المتجر'),
          const SizedBox(height: 8),
          _buildStoreManagementFeatures(),
          const SizedBox(height: 24),
          
          // Store Statistics
          _buildSectionTitle('إحصائيات المتجر'),
          const SizedBox(height: 8),
          _buildStoreStatistics(),
          const SizedBox(height: 24),
          
          // Recent Orders
          _buildSectionTitle('الطلبات الجديدة'),
          const SizedBox(height: 8),
          _buildStoreOrders(),
        ],
      ),
    );
  }

  // Service Provider Profile Content
  Widget _buildServiceProviderProfile(Map<String, dynamic>? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Card
          _buildUserInfoCard(user),
          const SizedBox(height: 16),
          
          // Service Management
          _buildSectionTitle('إدارة الخدمات'),
          const SizedBox(height: 8),
          _buildServiceManagementFeatures(),
          const SizedBox(height: 24),
          
          // Service Statistics
          _buildSectionTitle('إحصائيات الخدمات'),
          const SizedBox(height: 8),
          _buildServiceStatistics(),
          const SizedBox(height: 24),
          
          // Bookings
          _buildSectionTitle('الحجوزات'),
          const SizedBox(height: 8),
          _buildServiceBookings(),
        ],
      ),
    );
  }

  // Default Profile Content
  Widget _buildDefaultProfile(Map<String, dynamic>? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoCard(user),
          const SizedBox(height: 24),
          
          const Center(
            child: Text(
              'يرجى تسجيل الدخول لعرض الملف الشخصي',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // User Info Card
  Widget _buildUserInfoCard(Map<String, dynamic>? user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.orange,
              child: Text(
                user?['name']?.substring(0, 1).toUpperCase() ?? '؟',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?['name'] ?? 'غير معروف',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?['email'] ?? 'غير محدد',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getRoleDisplayName(user?['role_type']),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Helper
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Client-specific features
  Widget _buildClientFeatures() {
    return Card(
      child: Column(
        children: [
          _buildFeatureTile(Icons.shopping_cart, 'عربة التسوق', 'إدارة المنتجات المحفوظة'),
          _buildFeatureTile(Icons.favorite, 'المفضلة', 'عرض المنتجات المفضلة'),
          _buildFeatureTile(Icons.location_on, 'العناوين', 'إدارة عناوين التسليم'),
          _buildFeatureTile(Icons.history, 'سجل الطلبات', 'عرض الطلبات السابقة'),
        ],
      ),
    );
  }

  // Store Owner features
  Widget _buildStoreManagementFeatures() {
    return Card(
      child: Column(
        children: [
          _buildFeatureTile(Icons.store, 'إعدادات المتجر', 'تحديث معلومات المتجر'),
          _buildFeatureTile(Icons.inventory, 'المنتجات', 'إدارة المنتجات والمخزون'),
          _buildFeatureTile(Icons.analytics, 'التقارير', 'عرض تقارير المبيعات'),
          _buildFeatureTile(Icons.people, 'العملاء', 'إدارة قاعدة العملاء'),
        ],
      ),
    );
  }

  // Service Provider features
  Widget _buildServiceManagementFeatures() {
    return Card(
      child: Column(
        children: [
          _buildFeatureTile(Icons.build, 'الخدمات', 'إدارة الخدمات المقدمة'),
          _buildFeatureTile(Icons.schedule, 'المواعيد', 'جدولة المواعيد'),
          _buildFeatureTile(Icons.star, 'التقييمات', 'عرض تقييمات العملاء'),
          _buildFeatureTile(Icons.payment, 'المدفوعات', 'إدارة المدفوعات'),
        ],
      ),
    );
  }

  // Feature Tile Helper
  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle feature navigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('سيتم تفعيل $title قريباً')),
        );
      },
    );
  }

  // Placeholder for specific content
  Widget _buildRecentOrders() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'لا توجد طلبات حديثة',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlist() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'لا توجد منتجات في قائمة الرغبات',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('المنتجات', '0'),
            _buildStatItem('الطلبات', '0'),
            _buildStatItem('المبيعات', '0 ر.س'),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('الخدمات', '0'),
            _buildStatItem('الحجوزات', '0'),
            _buildStatItem('الإيرادات', '0 ر.س'),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreOrders() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'لا توجد طلبات جديدة',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBookings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'لا توجد حجوزات',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _getRoleDisplayName(String? role) {
    switch (role) {
      case 'client':
        return 'عميل';
      case 'store_owner':
        return 'صاحب متجر';
      case 'service_provider':
        return 'مقدم خدمة';
      default:
        return 'غير محدد';
    }
  }
}
