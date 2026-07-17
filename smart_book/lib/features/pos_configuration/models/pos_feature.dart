enum PosFeature {
  barcode,
  weightScale,
  tables,
  takeaway,
  delivery,
  kitchenNotes,
  splitBill,
  batchTracking,
  expiryTracking,
  prescription,
  alternativeMedicine,
  vehicleFitment,
  sizeAndColor,
  serialNumber,
}

extension PosFeatureDetails on PosFeature {
  String get title => switch (this) {
        PosFeature.barcode => 'الباركود',
        PosFeature.weightScale => 'البيع بالوزن',
        PosFeature.tables => 'إدارة الطاولات',
        PosFeature.takeaway => 'طلبات سفري',
        PosFeature.delivery => 'طلبات التوصيل',
        PosFeature.kitchenNotes => 'ملاحظات المطبخ',
        PosFeature.splitBill => 'تقسيم الفاتورة',
        PosFeature.batchTracking => 'التشغيلة (Batch)',
        PosFeature.expiryTracking => 'تاريخ الصلاحية',
        PosFeature.prescription => 'الوصفة الطبية',
        PosFeature.alternativeMedicine => 'البدائل الدوائية',
        PosFeature.vehicleFitment => 'توافق السيارة وOEM',
        PosFeature.sizeAndColor => 'المقاس واللون',
        PosFeature.serialNumber => 'الرقم التسلسلي',
      };

  String get description => switch (this) {
        PosFeature.barcode => 'البحث وإضافة الصنف بالماسح الضوئي.',
        PosFeature.weightScale => 'إدخال وزن الصنف عند البيع.',
        PosFeature.tables => 'ربط الطلب بطاولة وحالتها.',
        PosFeature.takeaway => 'إنشاء طلب للاستلام من الفرع.',
        PosFeature.delivery => 'إنشاء طلب توصيل وربطه بالعنوان.',
        PosFeature.kitchenNotes => 'إرسال ملاحظات خاصة للمطبخ.',
        PosFeature.splitBill => 'تقسيم قيمة الطلب على أكثر من فاتورة.',
        PosFeature.batchTracking => 'اختيار التشغيلة عند بيع الدواء.',
        PosFeature.expiryTracking => 'تنبيه الصلاحية عند البيع.',
        PosFeature.prescription => 'تسجيل بيانات الوصفة عند الحاجة.',
        PosFeature.alternativeMedicine => 'عرض البدائل المتاحة للدواء.',
        PosFeature.vehicleFitment => 'تحديد السيارة ورقم القطعة.',
        PosFeature.sizeAndColor => 'اختيار المتغير مثل المقاس واللون.',
        PosFeature.serialNumber => 'تسجيل الرقم التسلسلي للصنف.',
      };
}
