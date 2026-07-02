class JournalDetailModel {
  final int? accountId;
  final String accountName;
  final double debit;
  final double credit;
  final String description;

  JournalDetailModel({
    this.accountId,
    required this.accountName,
    required this.debit,
    required this.credit,
    required this.description,
  });

  // 🚀 أضف هذا الجزء لحل المشكلة
  factory JournalDetailModel.fromJson(Map<String, dynamic> json) {
    return JournalDetailModel(
      accountId: json['accountId'],
      accountName: json['accountName'] ?? 'غير معرف',
      // تحويل القيم إلى double لضمان عدم حدوث خطأ إذا كانت قادمة كـ int
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
    );
  }

  // نحتاجه أيضاً عند الحفظ للسيرفر
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountName': accountName,
      'debit': debit,
      'credit': credit,
      'description': description,
    };
  }
}