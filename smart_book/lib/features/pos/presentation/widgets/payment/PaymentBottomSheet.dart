import '../../../../../core/packages.dart';
import '../../../core/PaymentMethod.dart';

class PaymentBottomSheet extends StatelessWidget {
  final double totalAmount;
  final Function(PaymentMethod method) onConfirmPayment;

  const PaymentBottomSheet({
    super.key,
    required this.totalAmount,
    required this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان النافذة
          const Text(
            "اختر طريقة الدفع",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),

          // عرض الإجمالي المطلوب
          Text(
            "الإجمالي المطلوب: $totalAmount ر.س",
            style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const Divider(height: 30),

          // أزرار طرق الدفع
          _buildPaymentOption(
            context,
            title: "نقدي (Cash)",
            icon: Icons.money,
            color: Colors.green,
            method: PaymentMethod.cash,
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(
            context,
            title: "شبكة / بطاقة (Card)",
            icon: Icons.credit_card,
            color: Colors.blue,
            method: PaymentMethod.card,
          ),
          const SizedBox(height: 10),
          _buildPaymentOption(
            context,
            title: "آجل / ذمم (Credit)",
            icon: Icons.person_add_alt_1,
            color: Colors.orange,
            method: PaymentMethod.credit,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required PaymentMethod method,
      }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        alignment: Alignment.centerRight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, color: color),
      label: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.pop(context); // إغلاق الـ BottomSheet
        onConfirmPayment(method); // تنفيذ عملية الدفع بالطريقة المختارة
      },
    );
  }
}