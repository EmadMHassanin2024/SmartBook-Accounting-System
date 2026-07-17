import 'package:smart_book/features/auth/auth_exports.dart';
import 'package:smart_book/features/pos/auth_exports.dart';

import '../widgets/pos_desktop_cart_panel.dart';
import '../widgets/pos_floating_cart_bar.dart';
import '../widgets/pos_product_grid.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PosCubit>().fetchInventoryProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
  }

}
