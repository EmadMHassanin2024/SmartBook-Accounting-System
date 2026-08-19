
import 'package:smart_book/features/pos/auth_exports.dart';



class POSCartDetailsScreen extends StatelessWidget {
  const POSCartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل السلة"),
      ),
      body: BlocConsumer<PosCubit, PosState>(
        listener: (context, state) {
          // التعامل مع حالة النجاح بعد الطباعة
          if (state is PosSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تمت العملية بنجاح!"),
                backgroundColor: Colors.green,
              ));
                // 2. تحديث المنتجات في الخلفية قبل الخروج (اختياري لكن مفضل)
                context.read<PosCubit>().fetchInventoryProducts();

                // 3. العودة التلقائية لشاشة الكاشير
                Navigator.pop(context);

            // ملاحظة: لا تقم بعمل pop هنا إذا كنت تريد بقاء المستخدم
            // في الصفحة ليرى رسالة "السلة فارغة"
          }

          if (state is PosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          // حالة التحميل (عند ضغط زر الدفع)
          if (state is PosSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          // حالة نجاح العملية (تظهر لثانية واحدة ثم يتم الانتقال التلقائي للبيانات الجديدة)
          if (state is PosSuccess) {
            return const Center(child: CircularProgressIndicator()); // أو رسالة نجاح
          }

          // الحالة الأهم: عرض البيانات
          if (state is PosLoaded) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text("السلة فارغة، ابدأ فاتورة جديدة"));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) => POSCartItem(item: state.cartItems[index]),
                  ),
                ),
                POSCartSummarySection(state: state),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

}