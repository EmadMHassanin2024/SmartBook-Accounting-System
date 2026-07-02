import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

import '../../finance/accounting/screens/account_statement_screen.dart';
import '../models/contact_model.dart';
class ContactCard extends StatelessWidget {
  final ContactModel contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    // تحديد لون الرصيد (أخضر إذا كان لنا، أحمر إذا كان علينا)
    final Color balanceColor = contact.currentBalance >= 0
        ? AppColors.successGreen
        : AppColors.errorRed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      child: InkWell(
        onTap: () {
          // الربط: الانتقال لصفحة كشف الحساب مع تمرير اسم العميل
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountStatementScreen(accountName: contact.name),
            ),
          );

           */
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
            ],
            // أضفت إطار خفيف جداً لتحسين المظهر عند النقر
            border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Icon(
                  contact.type == 'customer' ? Icons.person : Icons.store,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        contact.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                    Text(
                        "ضريبي: ${contact.taxNumber}",
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                      "الرصيد",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 10)
                  ),
                  Text(
                    "${contact.currentBalance.abs()} ريال",
                    style: TextStyle(
                        color: balanceColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  ),
                  Text(
                    contact.currentBalance >= 0 ? "لك" : "عليك",
                    style: TextStyle(color: balanceColor, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}