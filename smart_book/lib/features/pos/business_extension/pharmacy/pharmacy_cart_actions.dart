
import 'package:smart_book/features/pos/auth_exports.dart';


/// الأزرار الإضافية الخاصة بالصيدلية داخل السلة
List<Widget> buildPharmacyCartActions(CartItemModel item) {
  return [
    /// الوصفة الطبية
    IconButton(
      tooltip: "Prescription",
      icon: const Icon(
        Icons.receipt_long,
        size: 20,
      ),
      onPressed: () {
        // TODO:
        // فتح شاشة الوصفة الطبية
      },
    ),

    /// بدائل الدواء
    IconButton(
      tooltip: "Medicine Alternatives",
      icon: const Icon(
        Icons.medication,
        size: 20,
      ),
      onPressed: () {
        // TODO:
        // عرض بدائل الدواء
      },
    ),

    /// الجرعة
    IconButton(
      tooltip: "Dosage Instructions",
      icon: const Icon(
        Icons.local_hospital,
        size: 20,
      ),
      onPressed: () {
        // TODO:
        // عرض تعليمات الجرعة
      },
    ),

    /// ملاحظة
    IconButton(
      tooltip: "Notes",
      icon: const Icon(
        Icons.note_add,
        size: 20,
      ),
      onPressed: () {
        // TODO:
        // إضافة ملاحظة على المنتج
      },
    ),
  ];
}