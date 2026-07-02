// المكون الثاني: كارت عرض أسطر القيود المحاسبية

import '../../../../core/packages.dart';
import '../models/JournalDetailModel.dart';

class JournalLineCard extends StatelessWidget {
  final JournalDetailModel item;
  final VoidCallback onDelete;

  const JournalLineCard({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0.5,
      child: ListTile(
        title: Text(item.accountName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(item.description.isEmpty ? "بدون شرح تفصيلي" : item.description, style: const TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item.debit > 0) Text("مدين: ${item.debit.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                if (item.credit > 0) Text("دائن: ${item.credit.toStringAsFixed(2)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
