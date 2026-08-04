import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
import 'package:smart_book/features/pos/presentation/widgets/cart/pos_cart_item.dart';

import '../../../logic/PosState.dart';
import '../../../logic/pos_cubit.dart';
import '../summary/pos_cart_summary_section.dart';

// لوحة السلة للشاشات الكبيرة
class POSDesktopCartPanel extends StatelessWidget {
  const POSDesktopCartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        // استدعاء الـ Extension النشط من الكوبيت
        final activeExtension = context.read<PosCubit>().activeExtension;

        if (state is PosLoaded) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text("فاتورة جديدة",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),

              // 🌟 منطقة الأكشن المتغيرة (تظهر فقط إذا كان هناك Extension نشط)
              if (activeExtension != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: activeExtension.buildCartExtraActions(state.cartItems.first), // مثال بسيط
                  ),
                ),

              Expanded(
                child: state.cartItems.isEmpty
                    ? const Center(child: Text("السلة فارغة"))
                    : ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) =>
                      POSCartItem(item: state.cartItems[index]),
                ),
              ),

              POSCartSummarySection(state: state),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}