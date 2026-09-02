import 'package:smart_book/features/inventory/auth_exports.dart';

// زر إضافة منتج محسن بحيث يعتمد على السياق الحالي أو تمرير الـ Cubit دون الحاجة لـ GetIt المتكرر
class AddProductFAB extends StatelessWidget {
  const AddProductFAB({super.key});

  @override
  Widget build(BuildContext context) {


    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              // استخدام BlocProvider.value لاستخدام الـ Cubit الموجود أو تمريره بشكل نظيف
              value: sl<AddProductCubit>(),
              child: const AddProductScreen(),
            ),
          ),
        );

        // تحديث البيانات تلقائياً وفوراً إذا نجحت عملية الإضافة وعاد بـ true
        if (result == true && context.mounted) {

          context.read<InventoryCubit>().fetchProducts();
        }
      },
      child: const Icon(Icons.add),
    );
  }
}