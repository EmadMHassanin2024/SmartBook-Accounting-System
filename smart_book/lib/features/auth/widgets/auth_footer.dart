import '../../../../core/routes/app_routes.dart';

import 'package:smart_book/features/auth/auth_exports.dart'; // أو استيراد ملفات الترجمة

class AuthFooter extends StatelessWidget {
  final bool isLogin; // متغير وحيد وبسيط لمعرفة الحالة فقط

  const AuthFooter({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    // استخدام قيم افتراضية آمنة في حال كانت الترجمة null لمنع تحطم التطبيق
    final textValue = isLogin
        ? (lang?.dontHaveAccount ?? "Don't have an account?")
        : (lang?.alreadyHaveAccount ?? "Already have an account?");

    final actionTextValue = isLogin
        ? (lang?.createAccount ?? "Create Account")
        : (lang?.signIn ?? "Sign In");

    // تحديد النصوص والألوان والمسارات بناءً على الحالة تلقائياً دون تكرار
    final primaryColor = isLogin ? AppColors.primaryBlue : AppColors.qiwaBlue;
    final targetRoute = isLogin ? AppRoutes.signup : AppRoutes.login;

    final description = Text(
      textValue,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13, color: Colors.grey),
    );

    final action = GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, targetRoute);
      },
      child: Text(
        actionTextValue,
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