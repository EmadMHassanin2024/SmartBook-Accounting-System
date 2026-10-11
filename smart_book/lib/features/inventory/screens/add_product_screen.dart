import 'package:smart_book/features/inventory/auth_exports.dart';


class AddProductScreen extends StatelessWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  Widget build(BuildContext context) {
    final inventoryRepo =ProductRepository();
    return BlocProvider(
      create: (_) => AddProductCubit(
        inventoryRepo,
        productRepository: inventoryRepo,
        productToEdit: productToEdit,
      ),
          child:  const _AddProductView() ,

    );
  }
}
class _AddProductView extends StatelessWidget {
  final ProductModel? productToEdit;
  const _AddProductView({this.productToEdit});


  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final cubit = context.read<AddProductCubit>();
    final currentActivityType = context.read<SystemConfigurationCubit>()
        .state.settings.activeBusinessModule.name;

    final bool isEditing = productToEdit != null;
    return BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        } else if (state is AddProductError) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          SnackbarHelper.showError(state.message);
        } else if (state is AddProductSuccess) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
            SnackbarHelper.showSuccess(LanguageKeys.saveSuccessKey);

            Navigator.pop(context, true);
          }

      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AddProductAppBar(
          isEditing: isEditing,
          addProductTitleKey: LanguageKeys.addProductKey,
          actions: const [

            SizedBox(width: 16),
          ],
        ),
        body: BlocBuilder<AddProductCubit, AddProductState>(
          buildWhen: (previous, current) =>
          previous.isIngredient != current.isIngredient ||
              previous.units != current.units,
          builder: (context, addProductState) {
            return AddProductFormBody(
              formKey: formKey,
              cubit: cubit,
              addProductState: addProductState,
              currentActivityType: currentActivityType,
            );
          },
        ),
        bottomSheet: ProductSaveBottomSheet(
          onSavePressed: () {
            cubit.onSave(
              context: context,
              formKey: formKey,
              activityType: currentActivityType,
              productToEdit: productToEdit,
            );
          },
        ),
      ),
    );
  }
}