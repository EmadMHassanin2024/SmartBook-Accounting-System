import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/PosRepository.dart';

import '../models/invoice_model.dart';


import 'create_invoice_screen.dart';

class InvoicesListScreen extends StatelessWidget {
  const InvoicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء نسخة الـ Service المشتركة للنظام
    final PosRepository _posService =PosRepository();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'أرشيف الفواتير',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 16
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBg,
        elevation: 0.5,
      ),
      // 🎯 تحويل الـ body ليقرأ حياً من الـ SQL Server عبر الـ FutureBuilder
      body: FutureBuilder<List<dynamic>>(
        future: _posService.getAllInvoices(),
        builder: (context, snapshot) {
          // 1. حالة تحميل وانتظار البيانات
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              ),
            );
          }

          // 2. حالة حدوث خطأ أثناء جلب البيانات من السيرفر
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'حدث خطأ أثناء جلب الفواتير من السيرفر',
                style: TextStyle(color: AppColors.accentRed, fontWeight: FontWeight.bold),
              ),
            );
          }

          // 3. حالة نجاح الطلب ولكن قاعدة البيانات فارغة
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد فواتير حالياً في قاعدة البيانات',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            );
          }

          // 4. جلب البيانات بنجاح وتحويلها إلى أوبجكت الـ Model الخاص بك
          final List<dynamic> rawInvoices = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rawInvoices.length,
            itemBuilder: (context, index) {
              // خريطة البيانات القادمة من السيرفر
              final Map<String, dynamic> invoiceMap = rawInvoices[index];

              // تحويل دقيق للمفاتيح لتطابق ما يتوقعه الـ InvoiceModel.fromMap عندك
              final Map<String, dynamic> formattedMap = {
                'number': invoiceMap['invoiceNumber'] ?? 'بدون رقم',
                'customer': invoiceMap['customerName'] ?? 'عميل نقدي',
                'amount': (invoiceMap['totalAmount'] as num?)?.toDouble() ?? 0.0,
                'date': invoiceMap['invoiceDate'] != null
                    ? invoiceMap['invoiceDate'].toString().substring(0, 10).replaceAll('-', '/')
                    : 'بدون تاريخ',
                'status': invoiceMap['paymentStatus'] ?? invoiceMap['paymentType'] ?? 'مدفوعة',
              };

              return InvoiceListItem(
                invoiceModel: InvoiceModel.fromMap(formattedMap),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateInvoiceScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class InvoiceListItem extends StatelessWidget {
  final InvoiceModel invoiceModel;
  const InvoiceListItem({super.key, required this.invoiceModel});

  @override
  Widget build(BuildContext context) {
    // تحديد لون الحالة بناءً على النص القادم حياً من قاعدة البيانات
    final Color statusColor = (invoiceModel.status == 'مدفوعة' || invoiceModel.status == 'نقدي')
        ? AppColors.successGreen
        : AppColors.warningOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              invoiceModel.customerName,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.accentRed, // الأحمر المخصص للأسماء
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  " ريال",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: AppColors.highlightYellow, // الأصفر التجميلي تحت السعر
                          width: 3
                      ),
                    ),
                  ),
                  child: Text(
                    "${invoiceModel.totalAmount.toStringAsFixed(2)}", // منسق لخانة عشرية ثنائية ر.س
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  invoiceModel.date,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  "| رقم: ${invoiceModel.invoiceNumber}",
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: AppColors.dividerColor),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.description, color: statusColor, size: 18), // لون الحالة الحي
                    const SizedBox(width: 4),
                    Text(
                      invoiceModel.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.iconGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}