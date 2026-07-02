// lib/features/finance/adjustments/screens/adjustment_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart'; // تأكد من الاستيراد
import '../../../../l10n/app_localizations.dart';
import '../../../../core/di/service_locator.dart';

import '../../../auth/widgets/auth_app_bar.dart';
import '../../widgets/CommonReportFooter.dart';
import '../logic/adjustment_cubit.dart';
import '../logic/adjustment_state.dart';
import 'adjustment_list_screen.dart';

class AdjustmentListScreen extends StatelessWidget {
  const AdjustmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<AdjustmentCubit>()..fetchAdjustments(DateTime.now()),
      child: Scaffold(
        // 1. استخدام الكلاس الجاهز للهيدر
        appBar: const AuthAppBar(primaryColor: AppColors.primaryBlue),

        body: BlocBuilder<AdjustmentCubit, AdjustmentState>(
          builder: (context, state) {
            // ... (نفس منطق الـ Body السابق بدون تغيير)
            if (state is AdjustmentLoading) return const Center(child: CircularProgressIndicator());
            if (state is AdjustmentError) return Center(child: Text(state.message));

            if (state is AdjustmentLoaded) {
              return Column(
                children: [
                  Expanded(child: AdjustmentTable(entries: state.entries)),
                  CommonReportFooter(totals: [
                    {'title': "إجمالي التسويات", 'value': state.totalAmount.toStringAsFixed(2), 'color': Colors.blue},
                  ]),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),

        // 2. الفوتر (التنقل)
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            // منطق التنقل
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "التقارير"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "الإعدادات"),
          ],
        ),
      ),
    );
  }
}