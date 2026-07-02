import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/contact_list_view.dart';
import 'add_contact_screen.dart'; // تأكد من استيراد شاشة الإضافة هنا


class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

// إضافة SingleTickerProviderStateMixin ضرورية لعمل الـ TabController
class _ContactsListScreenState extends State<ContactsListScreen> with SingleTickerProviderStateMixin {

  // 1. تعريف المتغير هنا داخل الـ State
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2. تهيئة المتحكم
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // 3. تنظيف الذاكرة عند إغلاق الصفحة
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors. cardBg,
        elevation: 0.5,
        title: const Text(
          "دليل العملاء والموردين",
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController, // ربط المتحكم
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryBlue,
          tabs: const [
            Tab(text: "العملاء"),
            Tab(text: "الموردين"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController, // ربط المتحكم
        children: const [
          ContactsListView(type: 'customer'),
          ContactsListView(type: 'supplier'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 4. الآن سيتم التعرف على _tabController بدون مشاكل
          String currentType = _tabController.index == 0 ? 'customer' : 'supplier';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContactScreen(initialType: currentType),
            ),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        label: const Text("إضافة جديد", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}