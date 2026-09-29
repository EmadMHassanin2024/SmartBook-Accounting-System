import 'package:flutter/material.dart';
import 'package:smart_book/core/theme/app_colors.dart';

class POSErrorView extends StatelessWidget {
  final String message;
  const POSErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: AppColors.accentRed, fontSize: 16),
      ),
    );
  }
}