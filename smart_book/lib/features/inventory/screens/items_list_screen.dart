
import 'package:smart_book/features/inventory/auth_exports.dart';
import '../widgets/inventory_list/InventoryBodyContainer.dart';

class ItemsListScreen extends StatelessWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    return BlocProvider(
      create: (context) => InventoryCubit(
        InventoryRepository(),
        context.read<SystemConfigurationCubit>(),
      )..initialize(),

     */
    return BlocProvider(
      create: (context)=> InventoryCubit(
      )..initialize(),
      child: const Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: ItemsListAppBar(),

        body:InventoryBodyContainer(),

        floatingActionButton: AddProductFAB(),
      ),
    );
  }
}
