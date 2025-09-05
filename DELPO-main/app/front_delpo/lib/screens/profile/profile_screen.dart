import 'package:flutter/material.dart';


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

