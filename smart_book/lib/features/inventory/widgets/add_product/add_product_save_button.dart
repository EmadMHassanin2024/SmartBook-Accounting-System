import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductFAB extends StatelessWidget {
  const AddProductFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {

        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  const AddProductScreen(productToEdit: null),
          ),
        );


        if (result == true && context.mounted) {
          context.read<InventoryCubit>().fetchProducts();
        }
      },
      child: const Icon(Icons.add),
    );
  }
}