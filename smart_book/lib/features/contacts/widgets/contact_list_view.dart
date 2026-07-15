import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/contact_list_cubit.dart';
import '../logic/ContactListState.dart';
import 'contact_card.dart';

class ContactsListView extends StatelessWidget {
  final String type;
  const ContactsListView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // 1. جلب البيانات من الـ API عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactListCubit>().fetchContacts(type);
    });

    // 2. الاستماع لحالة الـ Cubit
    return BlocBuilder<ContactListCubit, ContactListState>(
      builder: (context, state) {
        if (state is ContactListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        else if (state is ContactListError) {
          return Center(child: Text("خطأ في الاتصال: ${state.message}"));
        }

        else if (state is ContactListLoaded) {
          // التحقق من أن القائمة ليست فارغة
          if (state.contacts.isEmpty) {
            return const Center(child: Text("لا توجد بيانات مسجلة"));
          }

          // 3. عرض البيانات الحقيقية القادمة من السيرفر
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.contacts.length,
            itemBuilder: (context, index) {
              return ContactCard(contact: state.contacts[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}