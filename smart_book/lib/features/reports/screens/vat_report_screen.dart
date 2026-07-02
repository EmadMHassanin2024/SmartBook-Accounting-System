import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';


class VatReportScreen extends StatelessWidget {
  const VatReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text("تقرير ضريبة القيمة المضافة", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.picture_as_pdf, color: Colors.red), onPressed: () {}),
          IconButton(icon: const Icon(Icons.explicit_outlined, color: Colors.green), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 1. شريط فلاتر التاريخ
          _buildFilterBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 2. كروت ملخص الضريبة
                  _buildVatSummaryCards(),
                  const SizedBox(height: 20),

                  // 3. جدول البيانات
                  _buildVatDataTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: _datePickerBtn("من: 2023-10-01")),
          const SizedBox(width: 10),
          Expanded(child: _datePickerBtn("إلى: 2023-12-31")),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _datePickerBtn(String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, size: 16, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildVatSummaryCards() {
    return Row(
      children: [
        _summaryItem("ضريبة المبيعات", "3,750", Colors.green),
        const SizedBox(width: 10),
        _summaryItem("ضريبة المشتريات", "1,200", Colors.orange),
        const SizedBox(width: 10),
        _summaryItem("صافي الضريبة", "2,550", AppColors.primaryBlue),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildVatDataTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: DataTable(
        columnSpacing: 15,
        headingRowHeight: 40,
        columns: const [
          DataColumn(label: Text("البيان", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("المبلغ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          DataColumn(label: Text("الضريبة", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text("مبيعات خاضعة")),
            DataCell(Text("25,000")),
            DataCell(Text("3,750")),
          ]),
          DataRow(cells: [
            DataCell(Text("مشتريات خاضعة")),
            DataCell(Text("8,000")),
            DataCell(Text("1,200")),
          ]),
        ],
      ),
    );
  }
}