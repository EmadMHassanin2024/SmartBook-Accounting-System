// ملف: contact_repository.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_config.dart';
import '../models/contact_model.dart';

class ContactRepository {
  // عنوان الخادم الأساسي
  static const String baseUrl = AppConfig.baseUrl;
  final _storage = const FlutterSecureStorage();

  // دالة خاصة للحصول على الترويسات اللازمة للطلب
  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'auth_token');
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // 1. جلب قائمة جهات الاتصال
  Future<List<ContactModel>> getContacts(String type) async {

    final String url = '$baseUrl/Contacts?type=$type';

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    //print(response.body);
    if (response.statusCode == 200) {
      // فك تشفير الاستجابة
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // الوصول إلى قائمة البيانات داخل المفتاح "data"
      final List<dynamic> dataList = responseBody['data'] as List<dynamic>? ?? [];

      // تحويل القائمة إلى قائمة من النماذج البرمجية
      return dataList.map((json) => ContactModel.fromMap(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception("فشل جلب جهات الاتصال: ${response.statusCode}");
    }
  }

  // 3. تحديث بيانات جهة اتصال موجودة
  Future<void> updateContact(ContactModel contact) async {
    // الرابط يتضمن الـ id الخاص بالعميل لتحديد من نريد تعديله
    final String url = '$baseUrl/Contacts/${contact.id}';

    final response = await http.put(
      Uri.parse(url),
      headers: await _getHeaders(),
      // نرسل البيانات المحدثة بصيغة JSON
      body: json.encode({
        'Phone': contact.phone,
        'TaxNumber': contact.taxNumber,
        // لا نرسل الاسم أو الرصيد إذا كنا لا نريد السماح بتعديلهم
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("فشل تحديث جهة الاتصال: ${response.statusCode}");
    }
  }
  // 2. إضافة جهة اتصال جديدة
  Future<void> addContact(ContactModel contact) async {
    final String url = '$baseUrl/Contacts';

    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      // تحويل النموذج إلى JSON
      body: json.encode(contact.toMap()), // تأكد أن النموذج يحتوي على دالة toMap()
    );
    //print(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل إضافة جهة الاتصال: ${response.statusCode}");
    }
  }
}