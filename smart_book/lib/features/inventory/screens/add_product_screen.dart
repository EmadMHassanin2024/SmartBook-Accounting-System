import 'package:smart_book/features/inventory/auth_exports.dart';


class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // 💡 الآن الـ Controllers آمنة ومستقرة داخل الـ State ولا يمكن تصفيرها أثناء البناء
  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _stockController;
  late final TextEditingController _reorderLevelController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _stockController = TextEditingController(text: "0");
    _reorderLevelController = TextEditingController(text: "5");
  }

  @override
  void dispose() {
    // 💡 تنظيف الذاكرة فور إغلاق الشاشة لمنع تسريب البيانات (Memory Leak)
    _nameController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    _reorderLevelController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context, AddProductState state) {
    if (_formKey.currentState!.validate()) {
      final baseUnit = state.units.first;

      if (baseUnit.salePrice <= 0) {
        _showSnackBar(context, "يرجى تحديد سعر البيع للوحدة الأساسية أولاً", Colors.orange);
        return;
      }

      context.read<AddProductCubit>().submitProduct(
        name: _nameController.text.trim(),
        barcode: _barcodeController.text.trim(),
        stock: int.tryParse(_stockController.text.trim()) ?? 0,
      );
    }
  }

  void _showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductCubit, AddProductState>(
      listenWhen: (previous, current) => current is AddProductSuccess || current is AddProductError || current is AddProductLoading,
      listener: (context, state) {
        if (state is AddProductLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            ),
          );
        } else {
          // 💡 تأمين الإغلاق: إذا كنا في حالة نجاح أو خطأ، نقوم بعمل pop للـ Loading Dialog أولاً بأمان
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          if (state is AddProductError) {
            _showSnackBar(context, state.message, Colors.red);
          } else if (state is AddProductSuccess) {
            // تحديث قائمة المخزن الرئيسية في الخلفية
            context.read<InventoryCubit>().fetchProducts();
            _showSnackBar(context, "تم حفظ الصنف بنجاح وبدقة محاسبية! ✅", Colors.green);
            Navigator.pop(context, true); // الرجوع لشاشة المخزن
          }
        }
      },
      child: BlocBuilder<AddProductCubit, AddProductState>(
        builder: (context, state) {
          final units = state.units;
          final baseUnitName = units.isNotEmpty && units[0].unitName.trim().isNotEmpty
              ? units[0].unitName
              : "قطعة";

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FD),
            appBar: AppBar(
              title: const Text("إضافة صنف جديد", style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionHeader("البيانات العامة", Icons.inventory_2),

                  BasicInfoCard(
                    nameController: _nameController,
                    barcodeController: _barcodeController,
                    stockController: _stockController,
                    baseUnitName: baseUnitName,
                  ),

                  const SizedBox(height: 12),
                  _buildReorderField(),

                  const SizedBox(height: 24),
                  _buildSectionHeader("وحدات القياس والأسعار", Icons.sell),

                  // كروت الوحدات الذكية والمربوطة بالـ Key الديناميكي للتحديث الفوري
                  ...units.asMap().entries.map((entry) {
                    final index = entry.key;
                    final unit = entry.value;
                    return UnitItemCard(
                      key: ValueKey('${index}_${unit.salePrice}_${unit.purchasePrice}_${unit.conversionFactor}'),
                      index: index,
                      unit: unit,
                      onDelete: () => context.read<AddProductCubit>().removeUnit(index),
                      onNameChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, name: val),
                      onSalePriceChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, salePrice: val),
                      onPurchasePriceChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, purchasePrice: val),
                      onFactorChanged: (val) => context.read<AddProductCubit>().updateUnitData(index: index, conversionFactor: val),
                    );
                  }).toList(),

                  const SizedBox(height: 12),
                  _buildAddUnitButton(context),

                  const SizedBox(height: 120),
                ],
              ),
            ),
            bottomSheet: _buildSaveButton(context, state),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildReorderField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined, color: Colors.orange),
          const SizedBox(width: 12),
          const Expanded(child: Text("نبهني عند وصول الكمية إلى:")),
          SizedBox(
            width: 60,
            child: TextField(
              controller: _reorderLevelController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(isDense: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddUnitButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => context.read<AddProductCubit>().addUnit(),
      icon: const Icon(Icons.add),
      label: const Text("إضافة وحدة بيع أخرى (جملة)"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AddProductState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: state is AddProductLoading ? null : () => _onSave(context, state),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "تأكيد وحفظ الصنف",
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}