import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'user_permissions_screen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  // بيانات تجريبية (سيتم ربطها بـ SQL Server في المرحلة القادمة)
  final List<Map<String, dynamic>> users = const [
    {
      "name": "أحمد المدير",
      "role": "مدير النظام",
      "status": true,
      "icon": Icons.admin_panel_settings
    },
    {
      "name": "سارة المحاسبة",
      "role": "محاسب",
      "status": true,
      "icon": Icons.account_balance
    },
    {
      "name": "خالد الكاشير",
      "role": "كاشير",
      "status": false,
      "icon": Icons.point_of_sale
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("إدارة المستخدمين",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.cardBg,
        elevation: 0.5,
        actions: [
          IconButton(
              onPressed: () {
                // هنا سيتم فتح شاشة إضافة مستخدم جديد
              },
              icon: const Icon(Icons.person_add_alt_1, color: AppColors.primaryBlue)
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              "الموظفين المسجلين بالنظام",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  // التعديل هنا: استخدام shape بدلاً من border المباشر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                      child: Icon(user['icon'], color: AppColors.primaryBlue),
                    ),
                    title: Text(
                      user['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(user['role'], style: const TextStyle(fontSize: 12)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusBadge(user['status']),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.iconGrey),
                      ],
                    ),
                    onTap: () {
                      // الانتقال لصفحة تعديل الصلاحيات الخاصة بهذا المستخدم
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserPermissionsScreen()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت حالة المستخدم (نشط/معطل)
  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "نشط" : "معطل",
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.red.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}