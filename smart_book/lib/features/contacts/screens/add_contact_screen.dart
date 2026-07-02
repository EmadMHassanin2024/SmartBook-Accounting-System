import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';


class AddContactScreen extends StatefulWidget {
  final String initialType; // 'customer' or 'supplier'

  const AddContactScreen({super.key, required this.initialType});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(_selectedType == 'customer' ? "إضافة عميل جديد" : "إضافة مورد جديد",
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors. cardBg,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. اختيار النوع (عميل أم مورد)
            _buildTypeSelector(),

            const SizedBox(height: 24),

            // 2. البيانات الأساسية
            _buildSectionTitle("البيانات الأساسية"),
            _buildTextField(label: "الاسم الكامل / اسم المؤسسة", icon: Icons.person_outline),
            _buildTextField(label: "رقم الجوال", icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),

            const SizedBox(height: 20),

            // 3. البيانات الضريبية والمالية
            _buildSectionTitle("البيانات المالية والضريبية"),
            _buildTextField(label: "الرقم الضريبي (اختياري)", icon: Icons.description_outlined, keyboardType: TextInputType.number),
            _buildTextField(label: "الرصيد الافتتاحي", icon: Icons.account_balance_outlined, keyboardType: TextInputType.number, suffix: "ريال"),

            const SizedBox(height: 32),

            // 4. زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // هنا سيتم الربط مع الـ API مستقبلاً
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("حفظ البيانات",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // وحدة اختيار نوع الحساب
  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _typeButton("عميل", 'customer')),
          Expanded(child: _typeButton("مورد", 'supplier')),
        ],
      ),
    );
  }

  Widget _typeButton(String label, String type) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              )),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(title, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, TextInputType? keyboardType, String? suffix}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.iconGrey, size: 20),
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.dividerColor)),
        ),
      ),
    );
  }
}