import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/contact_model.dart';
import 'EditContactScreen.dart';


class ContactCard extends StatelessWidget {
  final ContactModel contact;
  // أضفت الـ VoidCallback للتحكم الخارجي إذا احتجتِ،
  // ولكن سنستخدم navigator هنا مباشرة بناءً على طلبك
  final VoidCallback? onEdit;

  const ContactCard({super.key, required this.contact, this.onEdit});

  @override
  Widget build(BuildContext context) {
    // منطق الحالة المحاسبية: المدين موجب، الدائن سالب
    final bool isDebit = contact.currentBalance > 0;
    final bool isCredit = contact.currentBalance < 0;

    // الألوان: الأحمر للمدين (مستحقات)، الأخضر للدائن (إيجابي)
    final Color balanceColor = isDebit ? AppColors.errorRed : (isCredit ? AppColors.successGreen : AppColors.textSecondary);
    final String statusLabel = isDebit ? "مدين" : (isCredit ? "دائن" : "متوازن");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                    contact.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
              // زر التعديل - معالج بشكل موحد
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primaryBlue),
                onPressed: () {
                  // الانتقال لصفحة التعديل
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditContactScreen(contact: contact),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(Icons.phone, "جوال: ${contact.phone.isEmpty ? '---' : contact.phone}"),

              // عرض الرصيد مع الحالة المحاسبية
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      "${contact.currentBalance.abs().toStringAsFixed(2)} ريال",
                      style: TextStyle(color: balanceColor, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  Text(
                      statusLabel,
                      style: TextStyle(color: balanceColor, fontSize: 10, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)
        ),
      ],
    );
  }
}