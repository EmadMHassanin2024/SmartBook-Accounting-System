import '../../../core/packages.dart';
import '../Repository/contact_repository.dart';
import '../models/contact_model.dart';
import 'ContacState.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository _contactRepository;

  ContactCubit(this._contactRepository) : super(ContactInitial());

  // دالة الإضافة
  Future<void> addContact(ContactModel contact) async {
    emit(ContactLoading());
    try {
      await _contactRepository.addContact(contact);
      emit(ContactSuccess());
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  // دالة التعديل
  Future<void> updateContact(ContactModel contact) async {
    emit(ContactLoading());
    try {
      await _contactRepository.updateContact(contact);
      emit(ContactSuccess());
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }

  void resetState() {
    emit(ContactInitial());
  }
}

