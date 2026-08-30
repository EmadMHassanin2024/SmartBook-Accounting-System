import 'package:smart_book/features/auth/auth_exports.dart';

import '../../../core/utils/extensions/localization_extension.dart';


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


    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: const AuthAppBar(primaryColor: AppColors.primaryBlue),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AuthFormContainerWidget(
                title: context.lang.signIn,
                subtitle: context.lang.signInSubtitle ?? 'to continue to your account',
                primaryColor: AppColors.primaryBlue,
                submitButtonText: context.lang.signIn.toUpperCase(),
                isLogin: true,
                onSubmitPressed: (formKey) {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<AuthCubit>().loginUser(
                      UserModel(
                        username: _usernameController.text.trim(),
                        password: _passwordController.text,
                      ),
                    );
                  }
                },
                children: [
                  CustomAuthInputField(label: context.lang.username, controller: _usernameController),
                  const SizedBox(height: 24),
                  CustomAuthInputField(label: context.lang.password, isPassword: true, controller: _passwordController),
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