
import '../../../../core/packages.dart';
import 'SummaryCard.dart';

class JournalHeader extends StatelessWidget {
  final String description;
  final double totalDebit;
  final double totalCredit;

  const JournalHeader({
    required this.description,
    required this.totalDebit,
    required this.totalCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: [
                const Icon(Icons.description_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "إجمالي المدين",
                    value: totalDebit.toStringAsFixed(2),
                    icon: Icons.arrow_downward,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SummaryCard(
                    title: "إجمالي الدائن",
                    value: totalCredit.toStringAsFixed(2),
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


