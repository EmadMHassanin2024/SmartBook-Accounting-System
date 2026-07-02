import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import '../../repositories/FinancialReportsRepository.dart';
import '../models/account_model.dart';


class ChartOfAccountsScreen extends StatefulWidget {
  const ChartOfAccountsScreen({super.key});

  @override
  State<ChartOfAccountsScreen> createState() => _ChartOfAccountsScreenState();
}

class _ChartOfAccountsScreenState extends State<ChartOfAccountsScreen> {
  final FinancialReportsRepository  _repo = FinancialReportsRepository ();
  List<AccountModel> _accounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    try {
      final data = await _repo.getAccounts(); // جلب البيانات من الـ API
      setState(() {
        _accounts = data.cast<AccountModel>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // يمكن إضافة SnackBar لعرض خطأ في حال فشل الاتصال
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text("دليل الحسابات"), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _accounts.length,
        itemBuilder: (context, index) => _buildAccountItem(context, _accounts[index]),
      ),
    );
  }

  Widget _buildAccountItem(BuildContext context, AccountModel account) {
    // تنسيق الرصيد: يظهر باللون الأحمر إذا كان سالباً، والأخضر إذا كان موجباً
    final balanceColor = (account.currentBalance ?? 0) >= 0 ? Colors.green : Colors.red;

    if (account.isMain ?? false) {
      return ExpansionTile(
        leading: const Icon(Icons.folder, color: Colors.amber),
        title: Text("${account.accountCode} - ${account.accountName}"),
        children: (account.children ?? []).map((child) => _buildAccountItem(context, child)).toList(),
      );
    } else {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: ListTile(
          leading: const Icon(Icons.account_balance_wallet, size: 20, color: Colors.blue),
          title: Text("${account.accountCode} - ${account.accountName}"),
          trailing: Text(
            (account.currentBalance ?? 0).toStringAsFixed(2),
            style: TextStyle(fontWeight: FontWeight.bold, color: balanceColor),
          ),
          onTap: () {
            // منطق الانتقال لكشف الحساب أو اختيار الحساب
          },
        ),
      );
    }
  }
}