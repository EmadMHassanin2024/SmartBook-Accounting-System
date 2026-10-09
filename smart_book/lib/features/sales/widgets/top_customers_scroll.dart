import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TopCustomersScroll extends StatelessWidget {
  final List<dynamic> customers; // استقبال قائمة العملاء ديناميكياً

  const TopCustomersScroll({super.key, required this.customers});

  @override
  Widget build(BuildContext context) {
    // التحقق إذا كانت القائمة فارغة لعرض رسالة مناسبة
    if (customers.isEmpty) {
      return SizedBox(
        height: 110,
        child: Center(
          child: Text(
            "لا توجد بيانات عملاء حالياً",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          // استخراج البيانات بناءً على المفاتيح القادمة من السيرفر أو الـ Repository
          final name = customer['name'] ?? 'عميل غير معروف';
          final val = customer['val']?.toString() ?? '0';

          return _customerCircle(name, val);
        },
      ),
    );
  }

  Widget _customerCircle(String name, String val) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: const Icon(Icons.person, size: 18, color: AppColors.primaryBlue),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            val,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.successGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}