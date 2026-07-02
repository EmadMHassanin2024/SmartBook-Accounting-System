import '../../accounting/models/JournalDetailModel.dart';

class JournalModel {
  final int entryId;
  final String? referenceNo; // جديد
  final String description;
  final String entryDate;
  final double totalDebit;   // جديد
  final double totalCredit;  // جديد
  final List<JournalDetailModel> details;
  JournalModel({
    required this.entryId,
    this.referenceNo,
    required this.description,
    required this.entryDate,
    required this.totalDebit,
    required this.totalCredit,
    required this.details,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      entryId: json['entryId'] ?? 0,
      referenceNo: json['referenceNo'], // سيقرأها تلقائياً إذا أرسلها السيرفر camelCase
      description: json['description'] ?? 'بدون بيان',
      entryDate: json['entryDate'] ?? '',
      // تحويل القيم إلى double لتناسب Flutter
      totalDebit: (json['totalDebit'] as num?)?.toDouble() ?? 0.0,
      totalCredit: (json['totalCredit'] as num?)?.toDouble() ?? 0.0,

      // التعديل هنا: تحويل List<dynamic> إلى List<JournalDetailModel>
      details: (json['details'] as List<dynamic>?)
          ?.map((item) => JournalDetailModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}