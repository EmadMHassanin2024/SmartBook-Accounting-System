


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/InvoiceRepository.dart';


import '../../finance/journals/repositories/JournalRepository.dart';
import '../models/invoice_model.dart'; // تأكد من استيراد الموديل المحدث
import '../models/invoice_item_model.dart';
import 'InvoiceState.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  final InvoiceRepository _invoiceService =InvoiceRepository();
  final JournalRepository _journalRepository = JournalRepository(); // تعريف الـ Repository

  InvoiceCubit() : super(InvoiceState(items: [], paymentMethod: "نقدي"));

  void changePaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }

  void addItem(InvoiceItemModel newItem) {
    final updatedItems = List<InvoiceItemModel>.from(state.items)..add(newItem);
    _updateTotals(updatedItems);
  }

  void incrementQuantity(int index) {
    final updatedItems = List<InvoiceItemModel>.from(state.items);
    updatedItems[index].quantity++;
    _updateTotals(updatedItems);
  }

  void decrementQuantity(int index) {
    final updatedItems = List<InvoiceItemModel>.from(state.items);
    if (updatedItems[index].quantity > 1) {
      updatedItems[index].quantity--;
      _updateTotals(updatedItems);
    }
  }

  void removeItem(int index) {
    final updatedItems = List<InvoiceItemModel>.from(state.items)..removeAt(index);
    _updateTotals(updatedItems);
  }

  // دالة الحفظ المحدثة بالربط الأوتوماتيكي
  Future<void> sendInvoiceToServer(String customerName, String paymentMethod) async {
    if (state.items.isEmpty) return;

    emit(state.copyWith(isLoading: true));

    try {
      bool isSuccess = await _invoiceService.submitInvoice(
        customerName: customerName.isEmpty ? "عميل نقدي" : customerName,
        items: state.items,
        totalAmount: state.finalTotal,
        paymentMethod: paymentMethod,
      );

      if (isSuccess) {
        // 💡 الربط الأوتوماتيكي: إنشاء القيد فور نجاح الفاتورة
        // سنقوم بإنشاء نسخة InvoiceModel (يجب أن تتوفر بيانات الإجمالي والضريبة في الحالة أو حسابها)
        final invoice = InvoiceModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // أو رقم الفاتورة الحقيقي من الـ Service
          invoiceNumber: "INV-${DateTime.now().microsecondsSinceEpoch}",
          customerName: customerName,
          totalAmount: state.finalTotal,
          subTotal: state.subTotal,
          tax: state.totalVat,
          date: DateTime.now().toIso8601String(),
          status: "مكتملة",
          items: state.items,
        );

        await _journalRepository.createAutomaticJournalFromInvoice(invoice);

        // تفريغ الفاتورة
        emit(InvoiceState(
          items: [],
          subTotal: 0,
          totalVat: 0,
          finalTotal: 0,
          isLoading: false,
          paymentMethod: "نقدي",
        ));
      } else {
        emit(state.copyWith(isLoading: false));
        throw Exception("فشلت عملية حفظ الفاتورة");
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  void _updateTotals(List<InvoiceItemModel> items) {
    double subTotal = 0;
    double totalVat = 0;

    for (var item in items) {
      subTotal += item.subTotal;
      totalVat += item.vatAmount;
    }

    emit(state.copyWith(
      items: items,
      subTotal: subTotal,
      totalVat: totalVat,
      finalTotal: subTotal + totalVat,
      isLoading: false,
    ));
  }
}