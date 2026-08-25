
import '../../../../core/routes/app_routes.dart'; // تأكد من مسار الـ routes الصحيح

import 'package:smart_book/features/auth/auth_exports.dart'; // أو استيراد ملفات الترجمة

class AuthFooter extends StatelessWidget {
  final bool isLogin; // متغير وحيد وبسيط لمعرفة الحالة فقط

  const AuthFooter({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    // تحديد النصوص والألوان والمسارات بناءً على الحالة تلقائياً دون تكرار
    final primaryColor = isLogin ? AppColors.primaryBlue : AppColors.qiwaBlue;
    final text = isLogin ? lang.dontHaveAccount : lang.alreadyHaveAccount;
    final actionText = isLogin ? lang.createAccount : lang.signIn;
    final targetRoute = isLogin ? AppRoutes.signup : AppRoutes.login;

    final description = Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13, color: Colors.grey),
    );

    final action = GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, targetRoute);
      },
      child: Text(
        actionText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 260) {
          return Column(children: [description, const SizedBox(height: 4), action]);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: description),
            const SizedBox(width: 5),
            action,
          ],
        );
      },
    );
  }
}