// ويدجت شريط الفلتر
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class FilterBarWidget extends StatelessWidget {
  const FilterBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // تعريف متغير اللغة هنا داخل دالة build
    final lang = AppLocalizations.of(context)!;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Text(
            "${lang.reportDate}: ${DateTime.now().toString().split(' ')[0]}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 14),
            label: Text(
              lang.changeDate,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}