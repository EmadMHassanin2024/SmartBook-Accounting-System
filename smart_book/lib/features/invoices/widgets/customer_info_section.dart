import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';


/// وظيفة الملف: يحتوي على الجزء العلوي من الفاتورة لجمع بيانات العميل والوقت.
class CustomerInfoSection extends StatelessWidget {
  const CustomerInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg, // تم الربط (أبيض)
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10
          )
        ],
      ),
      child: Column(
        children: [
          _buildField("اسم العميل", Icons.person_outline),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildField("رقم الفاتورة", Icons.numbers)),
              const SizedBox(width: 10),
              // الحقل المخصص للتاريخ (للقراءة فقط)
              Expanded(child: _buildField("التاريخ", Icons.calendar_today, isReadonly: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, {bool isReadonly = false}) {
    return TextField(
      readOnly: isReadonly,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, size: 20, color: AppColors.primaryBlue), // تم الربط
        filled: true,
        fillColor: AppColors.scaffoldBg, // تم الربط (الرمادي الفاتح جداً للخلفية)
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      ),
    );
  }
}