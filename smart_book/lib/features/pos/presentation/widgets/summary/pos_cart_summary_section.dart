
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/summary/pos_summary_panel.dart';


class POSCartSummarySection extends StatelessWidget {
  final PosLoaded state;

  const POSCartSummarySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return POSSummaryPanel(
      subTotal: state.subTotal,
      vatAmount: state.vatAmount,
      totalAmount: state.totalAmount,
      onConfirm: () {
        _openPaymentSheet(context);
      },
    );
  }

  void _openPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return PaymentBottomSheet(
          totalAmount: state.totalAmount,
          onConfirmPayment: (method) {
            context.read<PosCubit>().checkout(
              paymentType: method.name,
              invoiceItems: state.cartItems,
              finalTotal: state.totalAmount,
            );
          },
        );
      },
    );
  }
}
