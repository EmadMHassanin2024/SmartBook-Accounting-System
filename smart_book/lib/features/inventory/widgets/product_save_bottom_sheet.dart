import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/localization_extension.dart';
import '../logic/add_product_cubit.dart';
import '../logic/add_product_state.dart';

class ProductSaveBottomSheet extends StatelessWidget {
  final VoidCallback onSavePressed;

  const ProductSaveBottomSheet({super.key, required this.onSavePressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductCubit, AddProductState>(
      buildWhen: (previous, current) =>
      previous is AddProductLoading != current is AddProductLoading,
      builder: (context, state) {
        final isLoading = state is AddProductLoading;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onSavePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
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
                : Text(
              context.lang.confirmAndSave,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}