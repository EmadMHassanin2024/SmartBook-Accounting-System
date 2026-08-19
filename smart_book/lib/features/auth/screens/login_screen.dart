import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/routes/app_routes.dart';

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
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: const AuthAppBar(
        primaryColor: AppColors.primaryBlue,
      ),
      body: SafeArea(
        // 1. جعل الـ BlocConsumer مسؤولاً فقط عن الـ Listener (النجاح والخطأ)
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
          current is AuthSuccess || current is AuthError,
          listener: (context, state) {
            if (state is AuthSuccess) {
              SnackbarHelper.show(
                context,
                lang.registrationSuccess,
                AppColors.successGreen,
              );
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.main,
              );
            } else if (state is AuthError) {
              SnackbarHelper.show(
                context,
                state.message,
                AppColors.accentRed,
              );
            }
          },
          // 2. إرجاع true دائماً أو إزالتها طالما لن نعيد بناء الشاشة الكبرى بسبب الـ Loading
          buildWhen: (previous, current) => current is AuthInitial,
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          lang.signIn,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          lang.signInSubtitle ??
                              'to continue to your account',
                          style: const TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomAuthInputField(
                          label: lang.username,
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 24),
                        CustomAuthInputField(
                          label: lang.password,
                          isPassword: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 16),

                        // BlocBuilder منفصل للـ Checkbox
                        BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (previous, current) =>
                          current is AuthKeepMeSignedInChanged,
                          builder: (context, _) {
                            return LoginExtraOptions(
                              primaryColor: AppColors.primaryBlue,
                              isChecked: authCubit.keepMeSignedIn,
                              onChanged: (value) {
                                authCubit.toggleKeepMeSignedIn(
                                  value ?? false,
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // 3. BlocBuilder مستقل وخاص بزر تسجيل الدخول وحالة الـ Loading فقط
                        BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (previous, current) =>
                          current is AuthLoading ||
                              current is AuthSuccess ||
                              current is AuthError ||
                              current is AuthInitial,
                          builder: (context, buttonState) {
                            if (buttonState is AuthLoading) {
                              return const CircularProgressIndicator(
                                color: AppColors.primaryBlue,
                              );
                            }

                            return SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();

                                  if (_usernameController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    SnackbarHelper.show(
                                      context,
                                      'برجاء إدخال البيانات',
                                      AppColors.warningOrange,
                                    );
                                    return;
                                  }

                                  authCubit.loginUser(
                                    UserModel(
                                      username:
                                      _usernameController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  lang.signIn.toUpperCase(),
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
                          primaryColor: AppColors.primaryBlue,
                          text: lang.dontHaveAccount,
                          actionText: lang.createAccount,
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.signup);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}