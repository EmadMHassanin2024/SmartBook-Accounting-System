import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/core/theme/app_colors.dart';
import 'package:smart_book/features/pos/auth_exports.dart';

import '../../../logic/PosState.dart';
import '../../../logic/pos_cubit.dart';
import '../../screens/pos_cart_details.dart';
//الشريط العائم المخصص للموبايل والتابلت لإظهار ملخص سريع (الإجمالي وعدد العناصر) للمستخدم أثناء تنقله في قائمة المنتجات، وتوفر رابطاً سريعاً للانتقال لشاشة تفاصيل السلة
// الشريط العائم للموبايل
class POSFloatingCartBar extends StatelessWidget {
  const POSFloatingCartBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoaded && state.cartItems.isNotEmpty) {
          return Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Stack(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        "${state.cartItems.fold(0, (sum, item) => sum + item.quantity)}",
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text("${state.totalAmount.toStringAsFixed(2)} ر.س",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const POSCartDetailsScreen())),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}