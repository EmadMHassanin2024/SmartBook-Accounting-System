// ملف: contact_list_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../Repository/contact_repository.dart';
import '../models/contact_model.dart';
import 'ContactListState.dart';



class ContactListCubit extends Cubit<ContactListState> {
  final ContactRepository _contactRepository;

  ContactListCubit(this._contactRepository) : super(ContactListInitial());

  // دالة لجلب قائمة جهات الاتصال
  void fetchContacts(String type) async {
    emit(ContactListLoading());
    try {
      // جلب البيانات من المستودع
      final contacts = await _contactRepository.getContacts(type);
      emit(ContactListLoaded(contacts));
    } catch (e) {
      emit(ContactListError(e.toString()));
    }
  }
}