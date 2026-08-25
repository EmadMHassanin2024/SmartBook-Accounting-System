import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/SnackbarHelper.dart';
import '../widgets/auth_form_container_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.cardBg, //[cite: 5]
      appBar: const AuthAppBar(primaryColor: AppColors.qiwaBlue), //[cite: 5, 7]
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0), //[cite: 5]
              child: AuthFormContainerWidget(
                title: lang.signUp, //[cite: 5]
                primaryColor: AppColors.qiwaBlue, //[cite: 5]
                submitButtonText: lang.createAccount.toUpperCase(), //[cite: 5]
                successRoute: AppRoutes.login, //[cite: 5]
                isLogin: false, //[cite: 5]
                onSubmitPressed: (formKey) {
                  // التحقق من صحة الحقول عبر الـ formKey الداخلي
                  if (formKey.currentState?.validate() ?? false) {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      // ملاحظة: يفضل لاحقاً نقل النص إلى ملفات الترجمة لضمان دعم اللغات بالكامل
                      SnackbarHelper.showWarning('كلمات المرور غير متطابقة');
                      return;
                    }

                    // استدعاء دالة تسجيل الحساب
                    context.read<AuthCubit>().registerUser( //[cite: 5]
                      UserModel(
                        fullName: _fullNameController.text.trim(),
                        username: _usernameController.text.trim(),
                        password: _passwordController.text,
                      ),
                    );
                  }
                },
                children: [
                  CustomInputField(label: lang.fullName, controller: _fullNameController), //[cite: 5]
                  const SizedBox(height: 20), //[cite: 5]
                  CustomInputField(label: lang.username, controller: _usernameController), //[cite: 5]
                  const SizedBox(height: 20), //[cite: 5]
                  CustomInputField(label: lang.password, controller: _passwordController, isPassword: true), //[cite: 5]
                  const SizedBox(height: 20), //[cite: 5]
                  CustomInputField(label: lang.passwordConfirm, controller: _confirmPasswordController, isPassword: true), //[cite: 5]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}