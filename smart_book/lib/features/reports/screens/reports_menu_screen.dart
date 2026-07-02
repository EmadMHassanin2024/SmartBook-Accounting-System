import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'vat_report_screen.dart';

class ReportsMenuScreen extends StatelessWidget {
  const ReportsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("التقارير المالية والتحليلية",
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors. cardBg,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReportSection("التقارير الضريبية", [
            _ReportItem(
              title: "تقرير القيمة المضافة (VAT)",
              subtitle: "ملخص الضريبة المحصلة والمدفوعة",
              icon: Icons.pie_chart_outline,
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const VatReportScreen())),
            ),
          ]),
          const SizedBox(height: 20),
          _buildReportSection("التقارير المحاسبية", [
            _ReportItem(
              title: "ميزان المراجعة",
              subtitle: "أرصدة الحسابات المدينة والدائنة",
              icon: Icons.account_balance,
              color: Colors.purple,
              onTap: () {}, // سيتم برمجتها لاحقاً
            ),
            _ReportItem(
              title: "قائمة الدخل (الأرباح والخسائر)",
              subtitle: "صافي أداء المنشأة خلال فترة",
              icon: Icons.insights,
              color: Colors.green,
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 20),
          _buildReportSection("تقارير المستودعات", [
            _ReportItem(
              title: "حركة الأصناف",
              subtitle: "تفاصيل الوارد والمنصرف لكل صنف",
              icon: Icons.inventory_2_outlined,
              color: Colors.orange,
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildReportSection(String title, List<_ReportItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
          ),
          child: Column(
            children: items.map((item) => _buildListTile(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(_ReportItem item) {
    return ListTile(
      leading: Icon(item.icon, color: item.color),
      title: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: item.onTap,
    );
  }
}

class _ReportItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _ReportItem({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
}