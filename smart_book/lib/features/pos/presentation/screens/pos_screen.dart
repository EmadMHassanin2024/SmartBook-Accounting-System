import 'package:smart_book/features/pos/auth_exports.dart';
import '../../../../core/SnackbarHelper.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/language_keys.dart';
import '../../core/business_extension.dart';
import '../widgets/responsive/pos_responsive_layout.dart';

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PosCubit, PosState>(
      listenWhen: (_, current) =>
      current is PosError || current is PosSuccess,
      listener: (context, state) {
        if (state is PosError) {
          SnackbarHelper.showError(state.message);
        } else if (state is PosSuccess) {
          SnackbarHelper.showSuccess(
            context.translate(LanguageKeys.paymentSuccessMessage),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: BlocBuilder<PosCubit, PosState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              BusinessExtension? ext;
              if (state is PosLoadingProducts) ext = state.extension;
              if (state is PosLoaded) ext = state.extension;
              if (state is PosSubmitting) ext = state.extension;
              if (state is PosSuccess) ext = state.extension;
              if (state is PosError) ext = state.extension;

              return Text(
                ext != null
                    ? '${LanguageKeys.activity}: ${ext.extensionName}'
                    : context.translate(LanguageKeys.pointOfSaleGeneral),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: context.translate(LanguageKeys.systemSettings),
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