
import '../../../core/packages.dart';
import '../models/contact_model.dart';

@immutable
abstract class ContactListState {}

// الحالة الأولية للـ Cubit قبل بدء أي عملية
class ContactListInitial extends ContactListState {}

// حالة تحميل البيانات، يتم عرضها أثناء جلب القائمة من الـ API
class ContactListLoading extends ContactListState {}

// حالة نجاح جلب البيانات، تحتوي على القائمة التي تم جلبها من الـ API
class ContactListLoaded extends ContactListState {
  final List<ContactModel> contacts;
  ContactListLoaded(this.contacts);
}

// حالة حدوث خطأ، تحتوي على رسالة الخطأ لتنبيه المستخدم
class ContactListError extends ContactListState {
  final String message;
  ContactListError(this.message);
}