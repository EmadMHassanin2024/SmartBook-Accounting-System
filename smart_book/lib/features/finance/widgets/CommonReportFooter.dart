import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CommonReportFooter extends StatelessWidget {
  final List<Map<String, dynamic>> totals;

  const CommonReportFooter({
    super.key,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: totals.map((item) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (item['color'] as Color)
                      .withOpacity(0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item['icon'] != null)
                    Icon(
                      item['icon'],
                      color: item['color'],
                      size: 20,
                    ),

                  const SizedBox(height: 6),

                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    item['value'],
                    style: TextStyle(
                      color: item['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}