// lib/features/finance/income_statement/widgets/income_statement_filter_bar.dart
import '../../../../core/packages.dart';

class IncomeStatementFilterBar extends StatelessWidget {
  final VoidCallback onDatePick;
  final VoidCallback onRefresh;

  const IncomeStatementFilterBar({super.key, required this.onDatePick, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.date_range), onPressed: onDatePick),
        IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
        const Spacer(),
        IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: () {}),
        IconButton(icon: const Icon(Icons.table_chart), onPressed: () {}),
      ],
    );
  }
}