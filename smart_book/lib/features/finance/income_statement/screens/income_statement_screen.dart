// lib/features/finance/income_statement/screens/income_statement_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/widgets/auth_app_bar.dart';
import '../../journals/Widgets/SummaryCard.dart';
import '../logic/income_statement_cubit.dart';
import '../logic/income_statement_state.dart';
import '../widgets/income_statement_section_header.dart';

class IncomeStatementScreen extends StatelessWidget {
  const IncomeStatementScreen({super.key});

  Future<void> _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'SA'),
    );
    if (picked != null) {
      context.read<IncomeStatementCubit>().fetchIncomeStatement(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(
        primaryColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () => _pickDateRange(context),
          ),
        ],
      ),
      body: BlocBuilder<IncomeStatementCubit, IncomeStatementState>(
        builder: (context, state) {
          if (state is IncomeStatementLoading) return const Center(child: CircularProgressIndicator());

          if (state is IncomeStatementLoaded) {
            final data = state.model;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Expanded(child: SummaryCard(title: "الإيرادات", value: data.totalRevenue.toStringAsFixed(2), color: Colors.blue, icon: Icons.attach_money)),
                    Expanded(child: SummaryCard(title: "صافي الربح", value: data.netProfit.toStringAsFixed(2), color: data.netProfit >= 0 ? Colors.green : Colors.red, icon: Icons.attach_money)),
                  ],
                ),
                const SizedBox(height: 20),
                // استدعاء القسم الخاص بالجدول
                IncomeStatementSection(title: "الإيرادات", items: data.revenues),
                IncomeStatementSection(title: "المصروفات", items: data.expenses),
              ],
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("يرجى اختيار الفترة لعرض التقرير"),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickDateRange(context),
                  icon: const Icon(Icons.date_range),
                  label: const Text("اختيار الفترة"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
