import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import '../../settings/logic/SettingsCubit.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;
  final List<Widget>? actions;

  const AuthAppBar({
    super.key,
    required this.primaryColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cardBg,
      elevation: 0,
      leadingWidth: 120,

      // 🔹 زر اللغة
      leading: BlocBuilder<SettingsCubit, Locale>(
        builder: (context, locale) {
          final String nextLanguage = locale.languageCode == 'ar' ? "EN" : "AR";
          return InkWell(
            onTap: () => context.read<SettingsCubit>().toggleLanguage(),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.language, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 4),
                Text(nextLanguage, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),

      // 🔹 العنوان
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "SmartBook",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.account_balance_wallet, color: primaryColor, size: 28),
        ],
      ),
      centerTitle: true,

      // 🔹 دمج الأزرار المرسلة مع أي أزرار أخرى
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}