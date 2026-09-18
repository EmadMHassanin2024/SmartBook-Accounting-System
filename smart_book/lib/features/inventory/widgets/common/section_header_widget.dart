
import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../../core/localization/app_localizations.dart';
class SectionHeader extends StatelessWidget {
  final String titleKey;

  final IconData icon;

  const SectionHeader({super.key, required this.icon,
    required this.titleKey});

  @override
  Widget build(BuildContext context) {
    final displayedTitle = AppLocalizations.of(context)?.translate(titleKey) ?? titleKey;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text(
            displayedTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}