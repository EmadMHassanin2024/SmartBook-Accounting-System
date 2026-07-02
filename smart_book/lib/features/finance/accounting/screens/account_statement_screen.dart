import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/*

class AccountStatementScreen extends StatelessWidget {
  final String accountName;

  const AccountStatementScreen({super.key, required this.accountName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors. cardBg,
        elevation: 0.5,
        title: Text(
          "كشف حساب: $accountName",
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {}, // لمشاركة الكشف كـ PDF مستقبلاً
            icon: const Icon(Icons.share_outlined, color: AppColors.primaryBlue),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. بطاقة ملخص الرصيد (Header)
          _buildBalanceCard(),

          // 2. ترويسة الجدول (مدين، دائن، رصيد)
          _buildTableHeader(),

          // 3. قائمة الحركات المالية
          Expanded(
            child: ListView.builder(
              itemCount: 8, // بيانات تجريبية
              itemBuilder: (context, index) {
                return _buildTransactionItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF003D7A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const Column(
        children: [
          Text("إجمالي الرصيد المستحق", style: TextStyle(color: Colors.white70, fontSize: 13)),
          SizedBox(height: 8),
          Text("4,250.00 ريال", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text("التاريخ/البيان", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(child: Text("مدين (+)", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppColors.successGreen))),
          Expanded(child: Text("دائن (-)", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: AppColors.errorRed))),
          Expanded(child: Text("الرصيد", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTransactionItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Row(
        children: [
          // التاريخ والبيان
          const Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("2026/02/06", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                Text("فاتورة مبيعات #102", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          // مبلغ مدين
          const Expanded(child: Text("500.00", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.successGreen))),
          // مبلغ دائن
          const Expanded(child: Text("0.00", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          // الرصيد التراكمي
          const Expanded(child: Text("4,250.00", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue))),
        ],
      ),
    );
  }
}

 */