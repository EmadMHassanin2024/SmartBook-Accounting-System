import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePdfHelper {

  // 🎯 الدالة المربوطة بالواجهة لإطلاق المعاينة والطباعة الفورية
  static Future<void> generateAndPrintReceipt(
      List<dynamic> items, double total, String paymentType) async {

    final pdf = pw.Document();

    // تحميل خطوط جوجل (Cairo) لضمان طباعة الحروف العربية بشكل صحيح ومترابط
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    // حساب الحسابات الضريبية (15%) بناءً على الإجمالي القادم من الواجهة حياً
    double subTotal = total / 1.15;
    double vat = total - subTotal;

    // إعدادات حجم ورق الكاشير الحراري القياسي (Roll 80mm) مع الهوامش
    final pageFormat = PdfPageFormat.roll80.copyWith(
      marginTop: 10,
      marginBottom: 10,
      marginLeft: 10,
      marginRight: 10,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl, // توجيه النصوص من اليمين لليسار لدعم العربية
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // ترويسة الفاتورة (Header)
                pw.Center(
                  child: pw.Text(
                    "SMART BOOK",
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    "نظام إدارة المبيعات والمخازن",
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Divider(thickness: 1),

                // تفاصيل الفاتورة العامة
                pw.Text("التاريخ: ${DateTime.now().toString().substring(0, 16)}", style: const pw.TextStyle(fontSize: 8)),
                pw.Text("طريقة الدفع: $paymentType", style: const pw.TextStyle(fontSize: 8)),
                pw.Text("العميل: عميل نقدي", style: const pw.TextStyle(fontSize: 8)),
                pw.Divider(thickness: 1),

                // جدول أسطر المنتجات المباع
                pw.Text("الأصناف:", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),

                // بناء قائمة المنتجات حركياً بدون تعارض مع الكائن الداخلي
                ...items.map((item) {
                  // 🎯 تم التأمين: القراءة من كائن المنتج الداخلي لـ CartItemModel
                  final String name = item.product?.name ?? "صنف مبيعات";
                  final int qty = item.quantity ?? 1;
                  final double lineSubTotal = item.subTotal ?? 0.0;
                  final double unitPrice = item.product?.price ?? 0.0; // 👈 تم التعديل لتجنب الـ 0.00

                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // اسم المنتج بالكامل
                        pw.Text(name, style: const pw.TextStyle(fontSize: 8)),
                        pw.SizedBox(height: 2),
                        // تفاصيل الكمية × السعر المفرد والإجمالي الفرعي للسطر
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("$qty x ${unitPrice.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 8)),
                            pw.Text("${lineSubTotal.toStringAsFixed(2)} ر.س", style: const pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),

                pw.Divider(thickness: 1),

                // الحسابات والإجماليات النهائية المتزنة محاسبياً بالريال السعودي
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("المجموع الفرعي:", style: const pw.TextStyle(fontSize: 8)),
                    pw.Text("${subTotal.toStringAsFixed(2)} ر.س", style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("ضريبة القيمة المضافة (15%):", style: const pw.TextStyle(fontSize: 8)),
                    pw.Text("${vat.toStringAsFixed(2)} ر.س", style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.Divider(thickness: 0.5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("الإجمالي النهائي:", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    pw.Text("${total.toStringAsFixed(2)} ر.س", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ],
                ),

                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    "شكراً لتعاملكم معنا",
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // 🚀 تشغيل نافذة المعاينة والطباعة التلقائية حياً على المتصفح
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}