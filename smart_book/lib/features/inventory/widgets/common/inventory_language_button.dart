

import 'package:smart_book/features/inventory/auth_exports.dart';

class InventoryLanguageButton extends StatelessWidget {
  const InventoryLanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 320;
    if (isCompact) return const SizedBox.shrink();

    return BlocBuilder<SettingsCubit, Locale>(
      builder: (context, locale) {
        final String nextLanguage = locale.languageCode == 'ar' ? 'EN' : 'AR';
        return InkWell(
          onTap: () => context.read<SettingsCubit>().toggleLanguage(),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(
                Icons.language,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                nextLanguage,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}