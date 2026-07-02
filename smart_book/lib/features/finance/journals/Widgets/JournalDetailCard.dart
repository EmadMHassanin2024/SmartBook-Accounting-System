import '../../../../core/packages.dart';
import '../../accounting/models/JournalDetailModel.dart';

class JournalDetailCard extends StatelessWidget {
  final JournalDetailModel detail;

  const JournalDetailCard({
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _buildInfoRow(
              label: "الحساب",
              value: detail.accountName,
              color: Colors.blue,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    label: "مدين",
                    value: detail.debit > 0
                        ? detail.debit.toStringAsFixed(2)
                        : "-",
                    color: Colors.red,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildInfoRow(
                    label: "دائن",
                    value: detail.credit > 0
                        ? detail.credit.toStringAsFixed(2)
                        : "-",
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

  Widget _buildInfoRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),

        border: Border.all(
          color: color.withOpacity(0.20),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}