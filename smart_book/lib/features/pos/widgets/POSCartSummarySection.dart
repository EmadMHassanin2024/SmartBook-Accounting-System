import 'package:smart_book/features/auth/auth_exports.dart';
import 'package:smart_book/features/pos/auth_exports.dart';





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

        context.read<PosCubit>().checkout(
          paymentType: "نقدي",
          invoiceItems: state.cartItems,
          finalTotal: state.totalAmount,
        );
      },
    );
  }
}