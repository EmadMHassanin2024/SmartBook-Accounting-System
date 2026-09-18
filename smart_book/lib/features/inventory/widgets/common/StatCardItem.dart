import 'package:smart_book/features/inventory/auth_exports.dart';

class StatCardItem extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final VoidCallback? onTap;

  const StatCardItem({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              Text(title, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
            ],
          ),
        ),
      ),
    );
  }
}