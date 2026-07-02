import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UserPermissionsScreen extends StatefulWidget {
  const UserPermissionsScreen({super.key});

  @override
  State<UserPermissionsScreen> createState() => _UserPermissionsScreenState();
}

class _UserPermissionsScreenState extends State<UserPermissionsScreen> {
  // مصفوفة الصلاحيات (سيتم ربطها بجدول Permissions في SQL لاحقاً)
  Map<String, bool> permissions = {
    "دخول شاشة المبيعات (POS)": true,
    "إصدار مرتجع مبيعات": false,
    "رؤية تقارير الأرباح": false,
    "تعديل دليل الحسابات": false,
    "إضافة مستخدمين جدد": false,
    "تعديل المخزون": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الصلاحيات", style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              // منطق حفظ التعديلات في السيرفر
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم تحديث الصلاحيات بنجاح")),
              );
            },
            child: const Text("حفظ", style: TextStyle(color: AppColors.primaryBlue)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "تحديد صلاحيات الوصول لهذا المستخدم:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          ...permissions.keys.map((String key) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade100),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: SwitchListTile(
                secondary: Icon(
                  key.contains("الأرباح") ? Icons.monetization_on : Icons.lock_open,
                  color: permissions[key]! ? AppColors.primaryBlue : Colors.grey,
                ),
                title: Text(key, style: const TextStyle(fontSize: 14)),
                value: permissions[key]!,
                activeColor: AppColors.primaryBlue,
                onChanged: (bool value) {
                  setState(() {
                    permissions[key] = value;
                  });
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}