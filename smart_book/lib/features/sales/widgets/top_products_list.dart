import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TopProductsList extends StatelessWidget {
  final List<dynamic> products; // استقبال قائمة المنتجات ديناميكياً

  const TopProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // التحقق إذا كانت القائمة فارغة
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
        ),
        child: const Center(
          child: Text(
            "لا توجد منتجات الأكثر طلباً حالياً",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // لمنع التضارب في التمرير مع الـ SingleChildScrollView
        itemCount: products.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final product = products[index];
          // استخراج البيانات بناءً على المفاتيح القادمة من الـ API
          final name = product['name'] ?? 'منتج غير معروف';
          final qty = product['qty']?.toString() ?? '0';
          final total = product['total']?.toString() ?? '0 ر.س';

          return _productItem(name, qty, total);
        },
      ),
    );
  }

  Widget _productItem(String name, String qty, String total) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "الكمية المباعة: $qty",
        style: const TextStyle(fontSize: 11),
      ),
      trailing: Text(
        total,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}