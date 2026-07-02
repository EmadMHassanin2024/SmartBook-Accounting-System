
import 'package:smart_book/features/auth/auth_exports.dart';

class SignUpScreen extends StatefulWidget { // قمنا بتغيير الاسم ليتطابق مع LoginScreen
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // 🎯 الممارسة الأفضل: استخدام FormKey
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
      backgroundColor: AppColors.cardBg, // توحيد اللون مع شاشة الدخول
      appBar: const AuthAppBar(primaryColor:AppColors.qiwaBlue),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              SnackbarHelper.show(context, lang.registrationSuccess, AppColors.successGreen);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            } else if (state is AuthError) {
              SnackbarHelper.show(context, state.message, Colors.red);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: _formKey, // ربط الـ Form للتحقق
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(lang.signUp, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.qiwaBlue)),
                    const SizedBox(height: 30),

                    CustomInputField(label: lang.fullName, controller: _fullNameController),
                    const SizedBox(height: 20),
                    CustomInputField(label: lang.username, controller: _usernameController),
                    const SizedBox(height: 20),
                    CustomInputField(label: lang.password, controller: _passwordController, isPassword: true),
                    const SizedBox(height: 20),
                    CustomInputField(label: lang.passwordConfirm, controller: _confirmPasswordController, isPassword: true),

                    const SizedBox(height: 40),

                    state is AuthLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.qiwaBlue),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // إرسال البيانات للـ Cubit
                            final user = UserModel(
                              fullName: _fullNameController.text.trim(),
                              username: _usernameController.text.trim(),
                              password: _passwordController.text,
                            );
                            context.read<AuthCubit>().registerUser(user);
                          }
                        },
                        child: Text(lang.createAccount.toUpperCase(), style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthFooter(
                      primaryColor: AppColors.qiwaBlue,
                      text: lang.alreadyHaveAccount, // نص: "لديك حساب بالفعل؟"
                      actionText: lang.signIn,       // نص: "تسجيل الدخول"

                        onTap: () => Navigator.pushReplacementNamed(context, '/'), // المسار الرئيسي '/'
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