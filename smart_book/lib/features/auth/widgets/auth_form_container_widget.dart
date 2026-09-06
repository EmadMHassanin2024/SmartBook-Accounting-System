import 'package:smart_book/features/auth/auth_exports.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/SnackbarHelper.dart';
import '../../../core/utils/extensions/localization_extension.dart';
import 'CustomSubmitButtonWidge.dart';


class AuthFormContainerWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Color primaryColor;
  final String submitButtonText;
  final Function(GlobalKey<FormState> formKey) onSubmitPressed;
  final List<Widget> children;
  final bool isLogin;

  const AuthFormContainerWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.primaryColor,
    required this.submitButtonText,
    required this.onSubmitPressed,
    required this.children,
    this.isLogin = false,
  });

  @override
  State<AuthFormContainerWidget> createState() =>
      _AuthFormContainerWidgetState();
}

class _AuthFormContainerWidgetState
    extends State<AuthFormContainerWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Login Icon

            if (widget.isLogin) ...[
              const Icon(
                Icons.account_circle,
                size: 50,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 16),
            ],


            // Title

            Text(
              widget.title,
              style: TextStyle(
                fontSize: widget.isLogin ? 22 : 24,
                fontWeight: widget.isLogin
                    ? FontWeight.w500
                    : FontWeight.bold,
                color: widget.primaryColor,
              ),
            ),


            // Subtitle

            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                ),
              ),
            ],

            const SizedBox(height: 30),
            // Form Fields
            ...widget.children,

            const SizedBox(height: 30),
 
            // Authentication State
           
            BlocListener<AuthCubit, AuthState>(
              // Listener مسؤول فقط عن الـ Side Effects:
              // Navigation + Snackbar
              listenWhen: (previous, current) =>
              previous.status != current.status &&
                  (current.status == AuthStatus.success ||
                      current.status == AuthStatus.error),

              listener: (context, state) {
              
                // Success
              
                if (state.status == AuthStatus.success) {
                  if (widget.isLogin) {
                    SnackbarHelper.showSuccess(
                      context.lang.signIn,
                    );

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.main,
                    );
                  } else {
                    SnackbarHelper.showSuccess(
                      context.lang.registrationSuccess,
                    );

                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    );
                  }
                }

              
                // Error
              
                else if (state.status == AuthStatus.error) {
                  SnackbarHelper.showError(
                    state.errorMessage ??
                        context.lang.loginError,
                  );
                }
              },

              
              // Submit Button Builder
    
              child: BlocBuilder<AuthCubit, AuthState>(

                buildWhen: (previous, current) =>
                previous.status == AuthStatus.loading ||
                    current.status == AuthStatus.loading,

                builder: (context, state) {
                  return CustomSubmitButtonWidget(
                    formKey: _formKey,
                    primaryColor: widget.primaryColor,
                    buttonText: widget.submitButtonText,
                    isLoading:
                    state.status == AuthStatus.loading,
                    onPressed: () {
                      widget.onSubmitPressed(_formKey);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Auth Footer

            AuthFooter(
              isLogin: widget.isLogin,
            ),
          ],
        ),
      ),
    );
  }
}