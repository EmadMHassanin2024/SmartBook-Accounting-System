import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../pos/models/cart_item_model.dart';

class InvoicePdfHelper {
  static Future<void> generateAndPrintReceipt(List<CartItemModel> cartItems, double total, String paymentType) async {
    final pdf = pw.Document();

    // جلب خط عربي يدعم المتصفح والفلاتر ويب لمنع ظهور الحروف المقطعة
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    double subTotal = cartItems.fold(0.0, (sum, item) => sum + item.subTotal);
    double vat = subTotal * 0.15;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // مناسب لطباعة فواتير الكاشير الحرارية
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl, // دعم الكتابة من اليمين لليسار
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text("SMART BOOK POS", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Center(
                  child: pw.Text("فاتورة مبيعات مبسطة", style: pw.TextStyle(fontSize: 10)),
                ),
                pw.Divider(),
                pw.Text("تاريخ الفاتورة: ${DateTime.now().toString().substring(0, 16)}", style: pw.TextStyle(fontSize: 8)),
                pw.Text("طريقة الدفع: $paymentType", style: pw.TextStyle(fontSize: 8)),
                pw.Divider(),

                // جدول الأصناف
                pw.Table(
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text("الصنف", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        pw.Text("الكمية", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                        pw.Text("الإجمالي", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      ],
                    ),
                    ...cartItems.map((item) => pw.TableRow(
                      children: [
                        pw.Text(item.product.name, style: pw.TextStyle(fontSize: 7)),
                        pw.Text("${item.quantity}", style: pw.TextStyle(fontSize: 7)),
                        pw.Text("${item.subTotal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 7)),
                      ],
                    )),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text("المجموع الصافي:"), pw.Text("${subTotal.toStringAsFixed(2)} ر.س")],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [pw.Text("ضريبة القيمة المضافة 15%:"), pw.Text("${vat.toStringAsFixed(2)} ر.س")],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("الإجمالي النهائي:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("${total.toStringAsFixed(2)} ر.س", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  ],
                ),
                pw.Divider(),
                pw.Center(
                  child: pw.Text("شكراً لزيارتكم", style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                ),
              ],
            ),
          );
        },
      ),
    );

    // 👈 السطر السحري: يقوم بفتح نافذة الطباعة ومعاينة الـ PDF مباشرة على كروم
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}