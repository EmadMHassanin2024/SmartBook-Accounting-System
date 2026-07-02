
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SalesLineChart extends StatelessWidget {
  const SalesLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: const Center(
        child: Icon(Icons.stacked_line_chart, size: 50, color: AppColors.primaryBlue),
      ),
    );
  }
}

