
import 'package:smart_book/core/localization/language_keys.dart';
import 'package:smart_book/features/pos/auth_exports.dart';

import '../../../core/PaymentMethod.dart';


class POSCheckoutButton extends StatelessWidget {
  final double totalAmount;
  final VoidCallback? onConfirm;

  const POSCheckoutButton({
    super.key,
    required this.totalAmount,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: BlocBuilder<PosCubit, PosState>(
        builder: (context, state) {
          final isSubmitting = state is PosSubmitting;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSubmitting ? Colors.grey : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isSubmitting
                ? null
                : () {
              onConfirm?.call();
              _openPaymentSheet(context);
            },
            child: isSubmitting
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              LanguageKeys.confirmAndPay,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  void _openPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentBottomSheet(
        totalAmount: totalAmount,
        onConfirmPayment: (PaymentMethod method) {
          context.read<PosCubit>().checkoutWithMethod(method);
        },
      ),
    );
  }
}