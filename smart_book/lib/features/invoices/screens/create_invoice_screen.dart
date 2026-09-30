import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../pos/core/PaymentMethod.dart';
import '../../pos/logic/PosState.dart';
import '../../pos/logic/pos_cubit.dart';
import '../logic/InvoiceState.dart';
import '../logic/invoice_cubit.dart';


class CreateInvoiceScreen extends StatelessWidget {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PosCubit, PosState>(
      listener: (context, state) {
        if (state is PosSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تمت عملية الدفع وطباعة الفاتورة بنجاح!"),
            ),
          );
        }

        if (state is PosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: BlocBuilder<InvoiceCubit, InvoiceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: AppBar(
              title: const Text("إنشاء فاتورة جديدة"),
              centerTitle: true,
            ),
            body: Column(
              children: [
                _buildPaymentMethodSelector(context, state.paymentMethod),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
                _buildInvoiceSummaryCard(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInvoiceSummaryCard(BuildContext context, InvoiceState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row("الإجمالي الفرعي", "${state.subTotal.toStringAsFixed(2)} ريال"),
          _row("الضريبة (15%)", "${state.totalVat.toStringAsFixed(2)} ريال"),
          const Divider(height: 24, color: AppColors.dividerColor),
          _row("الإجمالي النهائي", "${state.finalTotal.toStringAsFixed(2)} ريال", isTotal: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (state.items.isEmpty || state.isLoading)
                  ? null
                  : () => _onConfirm(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27AE60),
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "تأكيد ودفع (F10)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm(BuildContext context, InvoiceState state) async {
    final method = PaymentMethod.values.firstWhere(
          (e) => e.name.toLowerCase() == state.paymentMethod.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );

    context.read<PosCubit>().checkoutWithMethod(method);
  }

  Widget _row(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 22 : 15,
              color: isTotal ? AppColors.primaryBlue : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector(BuildContext context, String currentMethod) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text("طريقة الدفع المحددة: $currentMethod"),
    );
  }
}