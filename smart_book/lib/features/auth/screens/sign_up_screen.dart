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
      appBar: const AuthAppBar(primaryColor: AppColors.qiwaBlue),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          // الاستماع فقط لحالات النجاح أو الخطأ
          listenWhen: (previous, current) =>
          current is AuthSuccess || current is AuthError,
          listener: (context, state) {
            if (state is AuthSuccess) {
              SnackbarHelper.show(
                context,
                lang.registrationSuccess,
                AppColors.successGreen,
              );
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            } else if (state is AuthError) {
              SnackbarHelper.show(
                context,
                state.message,
                AppColors.accentRed,
              );
            }
          },
          // منع إعادة بناء الشاشة بالكامل عند تغير حالات التحميل
          buildWhen: (previous, current) => current is AuthInitial,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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

                    // BlocBuilder مستقل وخاص بزر التسجيل وحالة التحميل فقط
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (previous, current) =>
                      current is AuthLoading ||
                          current is AuthSuccess ||
                          current is AuthError ||
                          current is AuthInitial,
                      builder: (context, buttonState) {
                        if (buttonState is AuthLoading) {
                          return const CircularProgressIndicator(
                            color: AppColors.qiwaBlue,
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
                              style: const TextStyle(color: Colors.white),
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
            );
          },
        ),
      ),
    );
  }
}