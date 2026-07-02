//لعرض الإجماليات والرصيد

import '../../../../core/packages.dart';
import '../../../../l10n/app_localizations.dart';
import '../logic/LedgerState.dart';

class LedgerSummaryHeader extends StatelessWidget {
  final LedgerLoaded state;
  const LedgerSummaryHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    double totalDebit = state.transactions.fold(0, (sum, item) => sum + item.debit);
    double totalCredit = state.transactions.fold(0, (sum, item) => sum + item.credit);
    double finalBalance = state.openingBalance + totalDebit - totalCredit;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blueGrey.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(lang.finalBalanceLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            finalBalance.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: finalBalance >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}