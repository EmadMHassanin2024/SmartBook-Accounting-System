import '../../../../core/packages.dart';
import '../Widgets/EmptyDetailsWidget.dart';
import '../Widgets/JournalDetailCard.dart';
import '../Widgets/JournalHeader.dart';
import '../models/JournalDetailModel.dart';
import '../models/JournalModel.dart';

class JournalDetailScreen extends StatelessWidget {
  final JournalModel journal;

  const JournalDetailScreen({
    super.key,
    required this.journal,
  });

  @override
  Widget build(BuildContext context) {
    final List<JournalDetailModel> details = journal.details;

    final totalDebit = details.fold<double>(0, (sum, item) => sum + item.debit);
    final totalCredit = details.fold<double>(0, (sum, item) => sum + item.credit);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("تفاصيل القيد #${journal.entryId}"),
        centerTitle: true,
      ),
      body: details.isEmpty
          ? const EmptyDetailsWidget()
          : Column(
        children: [
          JournalHeader(
            description: journal.description,
            totalDebit: totalDebit,
            totalCredit: totalCredit,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: details.length,
              itemBuilder: (context, index) {
                final detail = details[index];

                return JournalDetailCard(
                  detail: detail, // هنا نمرر السطر الحالي
                  journalId: journal.entryId, // هنا نمرر رقم القيد الأساسي
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}