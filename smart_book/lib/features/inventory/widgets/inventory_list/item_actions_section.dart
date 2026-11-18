import 'package:smart_book/features/inventory/auth_exports.dart';

import '../common/action_button_item.dart';


class ItemActionsSection extends StatelessWidget {
  final ProductModel product;

  const ItemActionsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bool isInStock = product.stock > 0;
    final int currentProductId = int.tryParse(product.id.toString()) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${product.price.toStringAsFixed(2)} ${context.lang.currency}",
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // زر التعديل
            ActionButtonItem(
              icon: Icons.edit,
              color: Colors.blue,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductScreen(productToEdit: product),
                  ),
                );
                if (result == true && context.mounted) {
                  context.read<InventoryCubit>().fetchProducts();
                }
              },
            ),
            const SizedBox(width: 6),

            // زر الحذف مع مراقبة حالة التحميل
            BlocBuilder<InventoryCubit, InventoryState>(
              buildWhen: (previous, current) =>
              current is DeleteProductLoading ||
                  current is DeleteProductSuccess ||
                  current is DeleteProductError,
              builder: (context, state) {
                final bool isDeletingThisItem =
                    state is DeleteProductLoading &&
                        state.productId == currentProductId;

                if (isDeletingThisItem) {
                  return Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    ),
                  );
                }

                return ActionButtonItem(
                  icon: Icons.delete_outline,
                  color: Colors.red,
                  onTap: () => _showDeleteConfirmationDialog(
                    context,
                    currentProductId,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),

            // شارة رصيد المخزون
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isInStock ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "${context.lang.stock}: ${product.stock}",
                style: TextStyle(
                  color: isInStock ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

