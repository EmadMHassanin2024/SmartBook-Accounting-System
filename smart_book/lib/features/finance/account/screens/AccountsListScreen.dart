import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ledger/Screans/ledger_screen.dart';

import '../logic/AccountState.dart';
import '../logic/account_cubit.dart'; // تأكد من المسار


class AccountsListScreen extends StatelessWidget {
  const AccountsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نقوم بجلب البيانات فور فتح الشاشة
    context.read<AccountCubit>().fetchAccounts();

    return Scaffold(
      appBar: AppBar(title: const Text("اختر الحساب")),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            return ListView.separated(
              itemCount: state.accounts.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (context, index) {
                final account = state.accounts[index];
                return ListTile(
                  title: Text(account.accountName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("النوع: ${account.accountType}"),
                  trailing: Text(
                    account.currentBalance.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // عند الضغط، ننتقل لـ LedgerScreen ونمرر الـ ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LedgerScreen(accountId: account.accountId),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is AccountError) {
            return Center(child: Text("خطأ: ${state.message}"));
          }
          return const Center(child: Text("لا توجد حسابات"));
        },
      ),
    );
  }
}