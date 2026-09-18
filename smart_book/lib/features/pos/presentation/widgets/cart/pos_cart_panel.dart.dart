
import 'package:smart_book/features/pos/auth_exports.dart';


// لوحة السلة للشاشات الكبيرة
class POSDesktopCartPanel extends StatelessWidget {
  const POSDesktopCartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        if (state is PosLoaded) {
          final activeExtension = state.extension;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "فاتورة جديدة",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              // تظهر أكشنات النشاط فقط عندما يوجد نشاط
              // وتوجد عناصر فعلية داخل السلة.
              if (activeExtension != null &&
                  state.cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Row(
                    children:
                    activeExtension.buildCartExtraActions(
                      state.cartItems.first,
                    ),
                  ),
                ),

              Expanded(
                child: state.cartItems.isEmpty
                    ? const Center(
                  child: Text("السلة فارغة"),
                )
                    : ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    return POSCartItem(
                      item: state.cartItems[index],
                    );
                  },
                ),
              ),

              POSCartSummarySection(
                state: state,
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}