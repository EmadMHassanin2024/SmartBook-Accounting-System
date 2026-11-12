import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductScreen extends StatelessWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  Widget build(BuildContext context) {

    if (!sl.isRegistered<AddProductCubit>()) {
      sl.registerLazySingleton(() => AddProductCubit(productRepository: sl<InventoryRepository>()));
    }
    return BlocProvider(
      create: (_) => sl<AddProductCubit>()..initProduct(productToEdit),
      child:AddProductView(productToEdit: productToEdit),

    );

  }
}

