import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductScreen extends StatelessWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  Widget build(BuildContext context) {
    final inventoryRepo = InventoryRepository();
    return BlocProvider(
      create: (_) => AddProductCubit(

        productRepository: inventoryRepo,
        productToEdit: productToEdit,
      ),

      child: AddProductView(productToEdit: productToEdit),
    );
  }
}

