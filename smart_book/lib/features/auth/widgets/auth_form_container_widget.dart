import 'package:smart_book/features/auth/auth_exports.dart';
import '../../../core/SnackbarHelper.dart';
import '../widgets/CustomSubmitButtonWidge.dart';


class AuthFormContainerWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Color primaryColor;
  final String submitButtonText;
  final String successRoute;
  final Function(GlobalKey<FormState> formKey) onSubmitPressed;
  final List<Widget> children;
  final bool isLogin;

  const AuthFormContainerWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.primaryColor,
    required this.submitButtonText,
    required this.successRoute,
    required this.onSubmitPressed,
    required this.children,
    this.isLogin = false,
  });

  @override
  State<AuthFormContainerWidget> createState() => _AuthFormContainerWidgetState();
}

class _AuthFormContainerWidgetState extends State<AuthFormContainerWidget> {
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _internalFormKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
      previous.status != current.status &&
          (current.status == AuthStatus.success ||
              current.status == AuthStatus.error),
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          // استخدام رسالة مترجمة أو افتراضية صحيحة
          SnackbarHelper.showSuccess(lang.registrationSuccess);
          Navigator.pushReplacementNamed(context, widget.successRoute);
        } else if (state.status == AuthStatus.error) {
          SnackbarHelper.showError(state.errorMessage ?? 'حدث خطأ ما');
        }
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
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
        child: Form(
          key: _internalFormKey,
          child: Column(
            children: [
              if (widget.isLogin) ...[
                const Icon(Icons.account_circle, size: 50, color: AppColors.primaryBlue),
                const SizedBox(height: 16),
              ],
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.isLogin ? 22 : 24,
                  fontWeight: widget.isLogin ? FontWeight.w500 : FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: const TextStyle(color: AppColors.greyText, fontSize: 14),
                ),
              ],
              const SizedBox(height: 30),
              ...widget.children,
              const SizedBox(height: 30),
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) => previous.status != current.status,
                builder: (context, state) {
                  return CustomSubmitButtonWidget(
                    formKey: _internalFormKey,
                    primaryColor: widget.primaryColor,
                    buttonText: widget.submitButtonText,
                    isLoading: state.status == AuthStatus.loading,
                    onPressed: () => widget.onSubmitPressed(_internalFormKey),
                  );
                },
              ),
              const SizedBox(height: 24),

              AuthFooter(isLogin: widget.isLogin),
            ],
          ),
        ),
      ),
    );
  }
}