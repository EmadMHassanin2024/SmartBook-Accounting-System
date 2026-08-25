import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/SnackbarHelper.dart';
import '../widgets/LoginKeepMeSignedInWidget.dart';
import '../widgets/auth_form_container_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: const AuthAppBar(primaryColor: AppColors.primaryBlue),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AuthFormContainerWidget(
                title: lang.signIn,
                subtitle: lang.signInSubtitle ?? 'to continue to your account',
                primaryColor: AppColors.primaryBlue,
                submitButtonText: lang.signIn.toUpperCase(),
                successRoute: AppRoutes.main,
                isLogin: true,
    onSubmitPressed: (formKey) {
    // الاعتماد على التحقق التلقائي للـ Form بدلاً من الشروط اليدوية غير المترجمة
    if (formKey.currentState?.validate() ?? false) {
    context.read<AuthCubit>().loginUser( //[cite: 4]
    UserModel(
    username: _usernameController.text.trim(),
    password: _passwordController.text,
    ),
    );
    }
    },


                children: [
                  CustomAuthInputField(label: lang.username, controller: _usernameController),
                  const SizedBox(height: 24),
                  CustomAuthInputField(label: lang.password, isPassword: true, controller: _passwordController),
                  const SizedBox(height: 16),
                  const LoginKeepMeSignedInWidget(primaryColor: AppColors.primaryBlue),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}