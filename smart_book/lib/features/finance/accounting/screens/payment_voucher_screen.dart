import 'package:flutter/material.dart';

// استيراد الموديل من المسار الذي حددته لحل مشكلة التضارب
import '../../../../core/theme/app_colors.dart';
import '../models/voucher_model.dart';

class VoucherScreen extends StatefulWidget {
  final VoucherType type; // يتم استخدامه الآن من ملف voucher_model.dart

  const VoucherScreen({super.key, required this.type});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // تم إزالة تعريف الـ enum من هنا لأنه موجود بالفعل في الموديل

  @override
  Widget build(BuildContext context) {
    // تحديد الهوية البصرية بناءً على نوع السند المستورد من الموديل
    final String title = widget.type == VoucherType.receipt ? "سند قبض نقدية" : "سند صرف نقدية";
    final Color themeColor = widget.type == VoucherType.receipt ? Colors.green.shade600 : Colors.red.shade600;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. بطاقة المبلغ (تصميم بارز واحترافي)
            _buildAmountCard(themeColor),

            const SizedBox(height: 25),

            // 2. تفاصيل السند (الاختيارات المحاسبية)
            _buildSelectionTile(
              label: "تاريخ السند",
              icon: Icons.calendar_month_outlined,
              value: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 12),

            _buildSelectionTile(
              label: widget.type == VoucherType.receipt ? "استلمنا من (الحساب)" : "صرفنا إلى (الحساب)",
              icon: Icons.account_tree_outlined,
              value: "اختر الحساب الفرعي...",
              onTap: () {
                // سيتم فتح شجرة الحسابات لاحقاً
              },
            ),
            const SizedBox(height: 12),

            _buildSelectionTile(
              label: "يؤثر على (الصندوق/البنك)",
              icon: Icons.account_balance_wallet_outlined,
              value: "الصندوق الرئيسي",
              onTap: () {},
            ),
            const SizedBox(height: 12),

            _buildSelectionTile(
              label: "مركز التكلفة (اختياري)",
              icon: Icons.business_center_outlined,
              value: "عام",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // 3. ملاحظات السند
            const Text("البيان / ملاحظات إضافية", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            _buildNoteField(),

            const SizedBox(height: 35),

            // 4. زر الحفظ النهائي
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // ويدجت بطاقة المبلغ
  Widget _buildAmountCard(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          const Text("المبلغ الإجمالي للسند", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          TextField(
            controller: _amountController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: "0.00",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
              suffixText: "ر.س",
              suffixStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت حقل الملاحظات
  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "اكتب تفاصيل العملية هنا...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  // ويدجت زر الحفظ
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () {
          // منطق الحفظ سيتم ربطه بـ SQL Server لاحقاً
        },
        icon: const Icon(Icons.print, color: Colors.white),
        label: const Text("حفظ وطباعة السند",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
        ),
      ),
    );
  }

  // ويدجت الاختيار الموحد
  Widget _buildSelectionTile({
    required String label,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primaryBlue, size: 22),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // وظيفة اختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}