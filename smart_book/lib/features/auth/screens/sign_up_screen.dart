import 'package:smart_book/features/auth/auth_exports.dart';
import 'package:smart_book/core/localization/app_localizations.dart';
import 'package:smart_book/core/localization/language_keys.dart';
import '../../../core/SnackbarHelper.dart';

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
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: const AuthAppBar(primaryColor: AppColors.qiwaBlue),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: AuthFormContainerWidget(
                title: context.translate(LanguageKeys.signUpKey),
                primaryColor: AppColors.qiwaBlue,
                submitButtonText: context.translate('create_account').toUpperCase(),
                isLogin: false,
                onSubmitPressed: (formKey) {
                  if (formKey.currentState?.validate() ?? false) {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      SnackbarHelper.showWarning(
                        context.translate('passwords_not_match').isNotEmpty
                            ? context.translate('passwords_not_match')
                            : 'كلمات المرور غير متطابقة',
                      );
                      return;
                    }

                    context.read<AuthCubit>().registerUser(
                      UserModel(
                        fullName: _fullNameController.text.trim(),
                        username: _usernameController.text.trim(),
                        password: _passwordController.text,
                      ),
                    );
                  }
                },
                children: [
                  CustomInputField(
                    label: context.translate('full_name'),
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: context.translate('username'),
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: context.translate('password'),
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: context.translate('password_confirm'),
                    controller: _confirmPasswordController,
                    isPassword: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}