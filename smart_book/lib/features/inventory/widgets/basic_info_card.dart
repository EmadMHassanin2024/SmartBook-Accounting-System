import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BasicInfoCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final String baseUnitName; // 💡 أضفنا المتغير هنا عشان يعرض اسم الوحدة الحقيقي

  const BasicInfoCard({
    super.key,
    required this.nameController,
    required this.barcodeController,
    required this.stockController,
    required this.baseUnitName, // تمرير ديناميكي
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text("المعلومات الأساسية", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          // 💡 هنا أضفنا الـ Validator لاسم الصنف
          _buildTextField(
            "اسم الصنف (أرز، زيت..)",
            nameController,
            Icons.shopping_bag_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'يرجى إدخال اسم الصنف';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildTextField("الباركود (اختياري)", barcodeController, Icons.qr_code_scanner),
          const SizedBox(height: 12),
          // عرض الكمية الافتتاحية مع اسم الوحدة الحية
          _buildTextField("الكمية الافتتاحية بـ ($baseUnitName)", stockController, Icons.inventory_2_outlined, isNumber: true),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String hint,
      TextEditingController controller,
      IconData icon, {
        bool isNumber = false,
        String? Function(String?)? validator, // 💡 بارامتر الـ validator الجديد
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: validator, // تشغيله هنا
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: AppColors.iconGrey),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}