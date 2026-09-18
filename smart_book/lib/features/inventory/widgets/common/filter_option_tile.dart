import 'package:smart_book/features/inventory/auth_exports.dart';

class FilterOptionTile extends StatelessWidget {
  final String displayTitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FilterOptionTile({
    super.key,
    required this.displayTitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          displayTitle,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
        onTap: onTap,
      ),
    );
  }
}