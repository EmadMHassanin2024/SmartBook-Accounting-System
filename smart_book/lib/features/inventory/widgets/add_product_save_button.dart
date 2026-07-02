import 'package:smart_book/features/inventory/auth_exports.dart';
import '../../../core/di/service_locator.dart';


// زر إضافة منتج (Floating Action Button) المطور بـ Dependency Injection
class AddProductFAB extends StatelessWidget {
  const AddProductFAB({super.key}); // تحسين الـ Constructor بإضافة الـ Key

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              // 🚀 استدعاء الـ Cubit نظيف ومستقل من الـ Locator ومبني بنظام Factory التصفيري
              create: (context) => sl<AddProductCubit>(),
              child: AddProductScreen(), // تم إزالة const لأن الشاشة أصبحت Stateless وتحمل Controllers داخلية
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