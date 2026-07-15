

import '../../../core/packages.dart';

@immutable
// ContactState.dart (الاسم الجديد للملف)
abstract class ContactState {}

class ContactInitial extends ContactState {}
class ContactLoading extends ContactState {}
class ContactSuccess extends ContactState {} // تستخدم للإضافة وللتعديل
class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
}