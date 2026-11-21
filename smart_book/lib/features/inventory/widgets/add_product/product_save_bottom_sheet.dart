import 'package:smart_book/features/inventory/auth_exports.dart';

class ProductSaveBottomSheet extends StatelessWidget {
  final VoidCallback onSavePressed;

  const ProductSaveBottomSheet({
    super.key,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocConsumer<AddProductCubit, AddProductState>(
          listenWhen: (previous, current) =>
          current is AddProductSuccess || current is AddProductError,
          listener: (context, state) {
            if (state case AddProductSuccess()) {
              SnackbarHelper.showSuccess(
                  LanguageKeys.savedSuccessfullyKey
              );
              if (context.mounted) Navigator.pop(context, true);
            } else if (state case AddProductError(:final message)) {
              SnackbarHelper.showError(message);
            }
          },
          buildWhen: (previous, current) =>
          current is AddProductLoading ||
              current is AddProductSuccess ||
              current is AddProductError ||
              current is AddProductInitial,
          builder: (context, state) {
            final bool isLoading = state is AddProductLoading;

            return ElevatedButton(
              onPressed: isLoading ? null : onSavePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor:
                AppColors.primaryBlue.withValues(alpha: 0.6),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const AppText(
                textKey: LanguageKeys.confirmAndSaveKey,
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}