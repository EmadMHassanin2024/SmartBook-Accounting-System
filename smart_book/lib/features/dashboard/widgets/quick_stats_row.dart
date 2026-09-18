import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../l10n/app_localizations.dart';
//يجمع الإحصائيات (المبيعات اليومية، سندات الصرف)
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow( {super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    // قيم افتراضية آمنة في حال كانت الترجمة null لتفادي الأخطاء
    final salesTodayText = lang?.salesToday ?? 'Sales Today';
    final paymentVouchersText = lang?.paymentVouchers ?? 'Payment Vouchers';

    return Row(
      children: [
        _statBox(salesTodayText, "1,250", Colors.green),
        const SizedBox(width: 12),
        _statBox(paymentVouchersText, "400", Colors.red),
      ],
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text("$value ريال", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}