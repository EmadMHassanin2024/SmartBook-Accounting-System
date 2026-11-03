import 'package:smart_book/features/pos/auth_exports.dart';

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentActivityType = context.read<SystemConfigurationCubit>()
        .state.settings.activeBusinessModule.name;

    return BlocListener<PosCubit, PosState>(
      listenWhen: (_, current) =>
      current is PosError || current is PosSuccess,
      listener: (context, state) {
        if (state is PosError) {
          SnackbarHelper.showError(state.message);
        } else if (state is PosSuccess) {
          SnackbarHelper.showSuccess(
            LanguageKeys.paymentSuccessMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText(
                textKey: LanguageKeys.activity,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                ': $currentActivityType',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

                    actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: LanguageKeys.systemSettings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SystemConfigurationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: const POSResponsiveLayout(),
      ),
    );
  }
}