import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/SnackbarHelper.dart';
import '../../finance/adjustments/logic/adjustment_cubit.dart';
import '../logic/InventoryState.dart';
import '../../../../core/utils/extensions/localization_extension.dart';

import '../data/repository/inventory_adjustment_screen.dart';
import '../widgets/item_card_widget.dart';

class InventoryListView extends StatelessWidget {
  final InventoryState state;

  const InventoryListView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is InventoryLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is InventoryError) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackbarHelper.showError(

          (state as InventoryError).message,
        );
      });
      return Center(child: Text(context.lang.errorOccurred));

    }

    if (state is InventoryLoaded) {
      final loadedState = state as InventoryLoaded;
      if (loadedState.products.isEmpty) {
        return Center(
          child: Text(
            context.lang.noItemsMatchSelection,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
        itemCount: loadedState.products.length,
        itemBuilder: (context, index) {
          final product = loadedState.products[index];

          return ItemCardWidget(
            product: product,
            // هنا قمنا بربط الزر بفتح شاشة الجرد
            onAdjustmentPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AdjustmentCubit>(),
                    child: InventoryAdjustmentScreen(product: product),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}