import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/pos/auth_exports.dart';
//شاشة الفاتورة المخصصة للشاشات الكبيرة لعرض السلة بشكل دائم بجانب المنتجات وتضم ملخص الفاتورة .

class POSDesktopCartPanel extends StatelessWidget {
  const POSDesktopCartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoaded) {
          return Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text("فاتورة جديدة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              Expanded(
                child: state.cartItems.isEmpty
                    ? const Center(child: Text("السلة فارغة"))
                    : ListView.builder(
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
    );
  }
}