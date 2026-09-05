/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../logic/ProductState.dart';
import '../logic/product_cubit.dart';
import '../../../core/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _costController;
  late final TextEditingController _priceController;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.product?.productNameAr ?? '',
    );

    _barcodeController = TextEditingController(
      text: widget.product?.barcode ?? '',
    );

    _costController = TextEditingController(
      text: widget.product?.costPrice.toString() ?? '',
    );

    _priceController = TextEditingController(
      text: widget.product?.sellingPrice.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _costController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    final product = ProductModel(
      productId: widget.product?.productId,
      productNameAr: _nameController.text.trim(),
      barcode: _barcodeController.text.trim(),
      costPrice: double.tryParse(_costController.text) ?? 0,
      sellingPrice: double.tryParse(_priceController.text) ?? 0,
    );

    if (isEdit) {
      context.read<ProductCubit>().updateProduct(product);
    } else {
      context.read<ProductCubit>().addProduct(product);
    }
  }

  Future<void> _deleteProduct() async {
    if (widget.product?.productId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل تريد حذف هذا المنتج؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context
          .read<ProductCubit>()
          .deleteProduct(widget.product!.productId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEdit
                    ? "تم تعديل المنتج بنجاح"
                    : "تمت إضافة المنتج بنجاح",
              ),
            ),
          );

          Navigator.pop(context, true);
        }

        if (state is ProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final loading = state is ProductLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEdit
                  ? "تعديل منتج"
                  : "إضافة منتج",
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "اسم المنتج",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: "الباركود",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "سعر التكلفة",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "سعر البيع",
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: loading ? null : _saveProduct,
                    child: loading
                        ? const CircularProgressIndicator()
                        : Text(
                      isEdit
                          ? "حفظ التعديلات"
                          : "إضافة المنتج",
                    ),
                  ),
                ),

                if (isEdit) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: loading ? null : _deleteProduct,
                      icon: const Icon(Icons.delete),
                      label: const Text("حذف المنتج"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

 */