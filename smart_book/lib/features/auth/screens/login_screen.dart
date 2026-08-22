
import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/routes/app_routes.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();

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
                AppRoutes.main,
              );
            } else if (state.status == AuthStatus.error) {
              SnackbarHelper.show(
                context,
                state.errorMessage ?? 'حدث خطأ ما',
                AppColors.accentRed,
              );
            }
          },
          child: Center(
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

                      // BlocBuilder خاص بالـ Checkbox فقط بناءً على تغير قيمة keepMeSignedIn
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>

                        previous.status == AuthStatus.loading ||
                            current.status == AuthStatus.loading,
                        builder: (context, state) {
                          return LoginExtraOptions(
                            primaryColor: AppColors.primaryBlue,
                            isChecked: state.keepMeSignedIn,
                            onChanged: (value) {
                              authCubit.toggleKeepMeSignedIn(
                                value ?? false,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // BlocBuilder خاص بزر تسجيل الدخول فقط بناءً على حالة الـ loading
                      BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                        previous.status != current.status,
                        builder: (context, buttonState) {
                          if (buttonState.status == AuthStatus.loading) {
                            return const SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
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
                                    username: _usernameController.text.trim(),
                                    password: _passwordController.text,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(4),
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
                            context,
                            AppRoutes.signup,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}