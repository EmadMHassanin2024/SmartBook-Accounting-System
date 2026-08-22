
import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/routes/app_routes.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

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
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: const AuthAppBar(
        primaryColor: AppColors.qiwaBlue,
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
          previous.status != current.status &&
              (current.status == AuthStatus.success ||
                  current.status == AuthStatus.error),
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              SnackbarHelper.show(
                context,
                lang.registrationSuccess,
                AppColors.successGreen,
              );

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.login,
              );
            } else if (state.status == AuthStatus.error) {
              SnackbarHelper.show(
                context,
                state.errorMessage ?? 'حدث خطأ ما',
                AppColors.accentRed,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    lang.signUp,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.qiwaBlue,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomInputField(
                    label: lang.fullName,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: lang.username,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: lang.password,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: lang.passwordConfirm,
                    controller: _confirmPasswordController,
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),

                  // BlocBuilder خاص بالزر فقط بناءً على حالة التحميل
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (previous, current) =>
                    previous.status == AuthStatus.loading ||
                        current.status == AuthStatus.loading,
                    builder: (context, buttonState) {
                      if (buttonState.status == AuthStatus.loading) {
                        return const SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.qiwaBlue,
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.qiwaBlue,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              authCubit.registerUser(
                                UserModel(
                                  fullName: _fullNameController.text.trim(),
                                  username: _usernameController.text.trim(),
                                  password: _passwordController.text,
                                ),
                              );
                            }
                          },
                          child: Text(
                            lang.createAccount.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  AuthFooter(
                    primaryColor: AppColors.qiwaBlue,
                    text: lang.alreadyHaveAccount,
                    actionText: lang.signIn,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      );
                    },
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