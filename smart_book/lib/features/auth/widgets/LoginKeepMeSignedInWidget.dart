
import 'package:smart_book/features/auth/auth_exports.dart';


class LoginKeepMeSignedInWidget extends StatelessWidget {
  final Color primaryColor;

  const LoginKeepMeSignedInWidget({
    super.key,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
      previous.keepMeSignedIn != current.keepMeSignedIn,

      builder: (context, state) {
        return LoginExtraOptions(
          primaryColor: primaryColor,
          isChecked: state.keepMeSignedIn,
          onChanged: (value) {
            context.read<AuthCubit>().toggleKeepMeSignedIn(value ?? false);
          },
        );
      },
    );
  }
}
