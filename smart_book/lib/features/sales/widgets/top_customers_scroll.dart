
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TopCustomersScroll extends StatelessWidget {
  const TopCustomersScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _customerCircle("شركة الحلول", "85K"),
          _customerCircle("مؤسسة الأمل", "60K"),
          _customerCircle("أحمد علي", "42K"),
          _customerCircle("توريدات الخليج", "30K"),
        ],
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
          Text(name,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(val, style: const TextStyle(fontSize: 11, color: AppColors.successGreen, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

