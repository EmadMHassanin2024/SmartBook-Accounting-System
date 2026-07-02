import 'package:smart_book/features/auth/auth_exports.dart';


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
    const Color qiwaBlue = AppColors.primaryBlue;
    const Color greyText = AppColors.greyText;

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: const AuthAppBar(primaryColor: qiwaBlue),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              SnackbarHelper.show(context, lang.registrationSuccess, AppColors.successGreen);
              Navigator.pushReplacementNamed(
                context,
                  '/main');

            } else if (state is AuthError) {
              SnackbarHelper.show(context, state.message, AppColors.accentRed);
            }
          },
          builder: (context, state) {
            final authCubit = context.read<AuthCubit>();

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.account_circle, size: 50, color: qiwaBlue),
                        const SizedBox(height: 16),
                        Text(lang.signIn, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        Text(lang.signInSubtitle ?? "to continue to your account", style: const TextStyle(color: greyText, fontSize: 14)),
                        const SizedBox(height: 32),

                        CustomAuthInputField(label: lang.username, controller: _usernameController),
                        const SizedBox(height: 24),
                        CustomAuthInputField(label: lang.password, isPassword: true, controller: _passwordController),

                        const SizedBox(height: 16),

                        // 🚀 الربط مع الكيبت (خيار تذكرني)
                        LoginExtraOptions(
                          primaryColor: qiwaBlue,
                          isChecked: authCubit.keepMeSignedIn,
                          onChanged: (val) => authCubit.toggleKeepMeSignedIn(val ?? false),
                        ),

                        const SizedBox(height: 24),

                        state is AuthLoading
                            ? const CircularProgressIndicator(color: qiwaBlue)
                            : SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                                SnackbarHelper.show(context, "برجاء إدخال البيانات", Colors.orange);
                                return;
                              }

                              final loginUser = UserModel(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text,
                              );
                              authCubit.loginUser(loginUser);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: qiwaBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Text(lang.signIn.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 🚀 الربط مع الـ AuthFooter المرن
                        AuthFooter(
                          primaryColor: qiwaBlue,
                          text: lang.dontHaveAccount,
                          actionText: lang.createAccount,
                          onTap: () => Navigator.pushReplacementNamed(context, '/signup'),

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