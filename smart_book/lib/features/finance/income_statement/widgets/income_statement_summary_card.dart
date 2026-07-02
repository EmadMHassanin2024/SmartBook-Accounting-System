// lib/features/finance/income_statement/widgets/income_statement_summary_card.dart
import '../../../../core/packages.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const SummaryCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}