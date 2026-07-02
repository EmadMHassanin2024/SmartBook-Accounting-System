import 'package:flutter/material.dart';
import 'package:smart_book/features/settings/screens/users_list_screen.dart';

import 'company_profile_screen.dart';




class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإعدادات العامة")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsTile(
            context,
            title: "بيانات المنشأة",
            subtitle: "الشعار، الرقم الضريبي، العنوان",
            icon: Icons.business,
            color: Colors.blue,
            destination: const CompanyProfileScreen(),
          ),
          const Divider(),
          _buildSettingsTile(
            context,
            title: "المستخدمين والصلاحيات",
            subtitle: "إدارة الأدوار، تفعيل/تعطيل الحسابات",
            icon: Icons.group_add,
            color: Colors.orange,
            destination: const UsersListScreen(), // سنبنيها لاحقاً
          ),
          const Divider(),
          _buildSettingsTile(
            context,
            title: "إعدادات الطباعة",
            subtitle: "ربط الطابعة، تنسيق الفاتورة",
            icon: Icons.print,
            color: Colors.teal,
            destination: const Center(child: Text("قريباً")),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color color, required Widget destination}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
    );
  }
}