import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/SnackbarHelper.dart';
import '../../../core/utils/extensions/localization_extension.dart';


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
                title: context.lang.signUp,
                primaryColor: AppColors.qiwaBlue,
                submitButtonText: context.lang.createAccount.toUpperCase(),
                isLogin: false,
                onSubmitPressed: (formKey) {
                  if (formKey.currentState?.validate() ?? false) {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      SnackbarHelper.showWarning(context.lang.passwordsNotMatch ?? 'كلمات المرور غير متطابقة');
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
                  CustomInputField(label:context. lang.fullName, controller: _fullNameController),
                  const SizedBox(height: 20),
                  CustomInputField(label: context.lang.username, controller: _usernameController),
                  const SizedBox(height: 20),
                  CustomInputField(label:context. lang.password, controller: _passwordController, isPassword: true),
                  const SizedBox(height: 20),
                  CustomInputField(label: context.lang.passwordConfirm, controller: _confirmPasswordController, isPassword: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}