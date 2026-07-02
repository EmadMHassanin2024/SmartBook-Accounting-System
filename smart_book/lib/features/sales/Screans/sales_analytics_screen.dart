import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

import '../widgets/line_chart_widget.dart';
import '../widgets/top_customers_scroll.dart';
import '../widgets/top_products_list.dart';


class SalesAnalyticsScreen extends StatelessWidget {
  const SalesAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("تحليلات المبيعات",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors. cardBg,
        elevation: 0.5,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("نمو المبيعات الشهري", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SalesLineChart(), // الويدجت المنفصل

            SizedBox(height: 24),

            Text("الأصناف الأكثر طلباً", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TopProductsList(), // الويدجت المنفصل

            SizedBox(height: 24),

            Text("أفضل 5 عملاء", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TopCustomersScroll(), // الويدجت المنفصل
          ],
        ),
      ),
    );
  }
}