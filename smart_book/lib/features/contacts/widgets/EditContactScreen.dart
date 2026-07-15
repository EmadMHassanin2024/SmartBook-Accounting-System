import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/packages.dart';
import '../logic/ContacState.dart';
import '../logic/ContactCubit.dart';
import '../models/contact_model.dart';


class EditContactScreen extends StatefulWidget {
  final ContactModel contact;
  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _taxNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _taxNumberController = TextEditingController(text: widget.contact.taxNumber);
  }

  @override
  Widget build(BuildContext context) {
    // منطق القفل: إذا كان الرصيد الحالي يختلف عن الرصيد الافتتاحي، فهذا يعني وجود حركات
    bool isReadOnly = widget.contact.currentBalance != widget.contact.openingBalance;

    return Scaffold(
      appBar: AppBar(title: const Text("تعديل بيانات العميل")),
      body: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state is ContactSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم التحديث بنجاح")));
            Navigator.pop(context); // العودة للشاشة السابقة
          } else if (state is ContactError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  enabled: !isReadOnly,
                  decoration: const InputDecoration(labelText: "الاسم", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: "الجوال", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _taxNumberController,
                  decoration: const InputDecoration(labelText: "الرقم الضريبي", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 24),

                // زر الحفظ
                state is ContactLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    // إنشاء نسخة معدلة من العميل
                    final updatedContact = widget.contact.copyWith(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      taxNumber: _taxNumberController.text,
                    );

                    // استدعاء دالة التحديث في الكيوبت
                    context.read<ContactCubit>().updateContact(updatedContact);
                  },
                  child: const Text("حفظ التعديلات"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}