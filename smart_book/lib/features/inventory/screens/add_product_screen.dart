import 'package:smart_book/features/inventory/auth_exports.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/language_keys.dart';
import '../widgets/common/inventory_language_button.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? productToEdit;
  const AddProductScreen({super.key, this.productToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final AddProductCubit cubit;
  late final String currentActivityType;
  bool get _isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();

    cubit = context.read<AddProductCubit>();

    currentActivityType = context.read<SystemConfigurationCubit>().state.settings.activeBusinessModule.name;
    // تهيئة الـ Controllers مرة واحدة فقط عند فتح الشاشة بأمان
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      cubit.initializeControllers(
        productToEdit: widget.productToEdit,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
          if (Navigator.canPop(context)) Navigator.pop(context);
          SnackbarHelper.showSuccess(LanguageKeys.saveSuccessKey);

          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AddProductAppBar(
          isEditing: _isEditing,
          addProductTitleKey: LanguageKeys.addProductKey,
          actions: const [
            InventoryLanguageButton(),
            SizedBox(width: 16),
          ],
        ),
        body: BlocBuilder<AddProductCubit, AddProductState>(
          buildWhen: (previous, current) =>

          previous.isIngredient != current.isIngredient ||
              previous.units != current.units,
          builder: (context, addProductState) {
            return AddProductFormBody(
              formKey: _formKey,
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
              formKey: _formKey,
              activityType: currentActivityType,
              productToEdit: widget.productToEdit,
            );
          },
        ),
      ),
    );
  }
}