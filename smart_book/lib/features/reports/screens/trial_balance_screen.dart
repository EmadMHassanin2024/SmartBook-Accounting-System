/*
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TrialBalanceScreen extends StatelessWidget {
  const TrialBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("ميزان المراجعة",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),

          // استخدام الـ Expanded مع SingleChildScrollView أفقي ورأسي
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // التمرير الرأسي
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // التمرير الأفقي لمنع التداخل
                    child: DataTable(
                      columnSpacing: 25, // توزيع المسافات بين الأعمدة
                      headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      columns: const [
                        DataColumn(label: Text('اسم الحساب')),
                        DataColumn(label: Text('مدين')),
                        DataColumn(label: Text('دائن')),
                        DataColumn(label: Text('الرصيد')),
                      ],
                      rows: [
                        _buildDataRow("الأصول المتداولة", 5000.0, 0.0, 5000.0),
                        _buildDataRow("إيرادات المبيعات", 0.0, 12000.0, -12000.0),
                        _buildDataRow("مصاريف التشغيل", 1500.0, 0.0, 1500.0),
                        _buildDataRow("حساب الصندوق", 3000.0, 500.0, 2500.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ملخص إجمالي في الأسفل
          _buildSummaryFooter(),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String name, double debit, double credit, double balance) {
    return DataRow(cells: [
      DataCell(SizedBox(
          width: 120, // تحديد عرض ثابت لاسم الحساب لمنع التمدد الزائد
          child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))
      )),
      DataCell(Text(debit.toString(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
      DataCell(Text(credit.toString(), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
      DataCell(Text(balance.toString(), style: TextStyle(color: balance >= 0 ? Colors.black : Colors.blue))),
    ]);
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          const Text("الفترة: 01/01 - 08/02", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, size: 14),
            label: const Text("تغيير", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("إجمالي المدين", "9,500", Colors.green),
          _summaryItem("إجمالي الدائن", "12,500", Colors.red),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

 */