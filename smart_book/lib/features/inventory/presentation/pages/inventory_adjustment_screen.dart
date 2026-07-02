
import 'package:smart_book/features/finance/adjustments/widgets/adjustment_form.dart';
import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../finance/adjustments/logic/adjustment_cubit.dart';
import '../../../finance/adjustments/logic/adjustment_state.dart';
import '../../../finance/adjustments/models/adjustment_entry.dart';




class InventoryAdjustmentScreen extends StatefulWidget {
  final ProductModel product;
  const InventoryAdjustmentScreen({super.key, required this.product});

  @override
  State<InventoryAdjustmentScreen> createState() => _InventoryAdjustmentScreenState();
}

class _InventoryAdjustmentScreenState extends State<InventoryAdjustmentScreen> {
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تسوية رصيد المخزون")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("صنف: ${widget.product.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("الرصيد في النظام: ${widget.product.stock}"),
            const SizedBox(height: 20),

            TextField(
              controller: _countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "الرصيد الفعلي (الذي عده المستخدم)"),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: "ملاحظات (السبب)"),
            ),
            const SizedBox(height: 30),

            BlocConsumer<AdjustmentCubit, AdjustmentState>(
              listener: (context, state) {
                if (state is AdjustmentSuccess) {
                  // 1. تحديث قائمة المنتجات
                  context.read<InventoryCubit>().fetchProducts();
                  Navigator.pop(context); // إغلاق الشاشة بعد النجاح
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم التحديث بنجاح")));

                } else if (state is AdjustmentError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AdjustmentLoading) return const CircularProgressIndicator();

                return ElevatedButton(
                  onPressed: () {
                    final transaction = InventoryTransaction(
                      productId: widget.product.id.toString(),
                      physicalCount: int.tryParse(_countController.text) ?? 0,
                      note: _noteController.text,
                      date: DateTime.now(),
                    );
                    context.read<AdjustmentCubit>().submitAdjustment(transaction as AdjustmentEntry);
                  },
                  child: const Text("حفظ التسوية"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}