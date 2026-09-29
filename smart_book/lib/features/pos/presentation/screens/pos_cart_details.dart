import 'package:smart_book/features/pos/auth_exports.dart';
import '../../../../core/SnackbarHelper.dart';
import '../../../../core/localization/language_keys.dart';
import '../widgets/cart/pos_error_view.dart';

import '../widgets/cart/pos_loaded_view.dart';
import '../widgets/cart/pos_loading_view.dart';
import 'package:smart_book/features/pos/presentation/widgets/cart/pos_loaded_view.dart';

class POSCartDetailsScreen extends StatelessWidget {
  const POSCartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // تم إضافة دالة الترجمة هنا
        title: const Text(LanguageKeys.pointOfSaleGeneral),
      ),
      body: BlocConsumer<PosCubit, PosState>(
        listenWhen: (_, current) =>
        current is PosSuccess || current is PosError,
        listener: (context, state) {
          if (state is PosSuccess) {
            SnackbarHelper.showSuccess(
              LanguageKeys.paymentSuccessMessage,
            );
            if (Navigator.canPop(context)) Navigator.pop(context);
          }

          if (state is PosError) {
            SnackbarHelper.showError(state.message);
          }
        },
        buildWhen: (_, current) =>
        current is PosInitial ||
            current is PosLoadingProducts ||
            current is PosSubmitting ||
            current is PosLoaded ||
            current is PosError,
        builder: (context, state) {
          if (state is PosInitial || state is PosLoadingProducts) {
            return const POSLoadingView();
          }

          if (state is PosSubmitting) {
            return const POSSubmittingView();
          }

          if (state is PosError) {
            return POSErrorView(message: state.message);
          }

          if (state is PosLoaded) {
            return POSLoadedView(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

