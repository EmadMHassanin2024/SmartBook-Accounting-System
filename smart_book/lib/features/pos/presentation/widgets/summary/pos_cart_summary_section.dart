
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/summary/pos_summary_panel.dart';

// قسم ملخص السلة الضريبي والحسابي

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