

import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import 'contact_card.dart';
//قائمة العملاء أو الموردين
class ContactsListView extends StatelessWidget {
  final String type;
  const ContactsListView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية لمحاكاة الواقع المحاسبي
    final List<ContactModel> dummyContacts = [
      ContactModel(
        id: "1",
        name: type == 'customer' ? "مؤسسة الرواد" : "شركة توريدات التقنية",
        phone: "0501234567",
        taxNumber: "310022334455003",
        openingBalance: 0.0,
        currentBalance: type == 'customer' ? 1500.0 : -2800.0, // الموجب لنا والسالب علينا
        type: type,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyContacts.length,
      itemBuilder: (context, index) {
        final contact = dummyContacts[index];
        return ContactCard(contact: contact);
      },
    );
  }
}
