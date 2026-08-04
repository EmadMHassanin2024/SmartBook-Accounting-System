import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_book/features/auth/auth_exports.dart';

import '../../logic/pos_cubit.dart';
import '../../logic/PosState.dart';

// تم تعديل مسار الاستيراد الصحيح للوحة السلة
import '../widgets/cart/pos_cart_panel.dart.dart';
import '../widgets/cart/pos_floating_cart_bar.dart';
import '../widgets/products/pos_product_grid.dart';

// استيراد شاشة إعدادات النظام الحقيقية (تأكد من تعديل المسار حسب مشروعك إذا لزم الأمر)
// import '../settings/system_configuration_screen.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  void initState() {
    super.initState();
    // 1. جلب المنتجات للمخزون
    context.read<PosCubit>().fetchInventoryProducts();

    // 2. تطبيق إعدادات النظام الحالية تلقائياً عند فتح الشاشة (إن وجدت مخزنة أو عبر الـ Cubit الخاص بالإعدادات)
    // مثال:
    // final savedSettings = context.read<SystemConfigurationCubit>().state.settings;
    // context.read<PosCubit>().applySettingsExtension(savedSettings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        final activeExtension = context.read<PosCubit>().activeExtension;

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Text(
                activeExtension != null
                    ? "وضع: ${activeExtension.extensionName}"
                    : "نقطة البيع (عام)"
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune), // أيقونة الإعدادات الحقيقية للنظام
                tooltip: "إعدادات النظام",
                onPressed: () {
                  // TODO: استبدل SystemConfigurationScreen بشاشة إعدادات النظام الحقيقية لديك
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SystemConfigurationScreen()),
                  );
                  */
                },
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    const Expanded(flex: 3, child: POSProductGrid()),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              left: BorderSide(color: Colors.grey, width: 0.2)),
                        ),
                        child: const POSDesktopCartPanel(),
                      ),
                    ),
                  ],
                );
              }
              return const Stack(
                children: [
                  POSProductGrid(),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: POSFloatingCartBar(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}