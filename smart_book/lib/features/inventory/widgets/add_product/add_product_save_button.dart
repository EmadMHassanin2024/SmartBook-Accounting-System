import 'package:smart_book/features/inventory/auth_exports.dart';

class AddProductFAB extends StatelessWidget {
  const AddProductFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // الانتقال للشاشة مباشرة دون تغليف إضافي، لأن الشاشة مكتفية ذاتياً (Self-contained)
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  const AddProductScreen(productToEdit: null),
          ),
        );

        // تحديث البيانات تلقائياً وفوراً إذا نجحت عملية الإضافة/التعديل وعاد بـ true
        if (result == true && context.mounted) {
          context.read<InventoryCubit>().fetchProducts();
        }
      },
      child: const Icon(Icons.add),
    );
  }
}