import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


import '../../../core/theme/app_colors.dart';
import '../logic/ContacState.dart';
import '../logic/ContactCubit.dart';

import '../models/contact_model.dart';

class AddContactScreen extends StatefulWidget {
  final String initialType;

  const AddContactScreen({super.key, required this.initialType});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  late String _selectedType;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _openingBalanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _taxNumberController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  // دالة الحفظ
  void _saveContact() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال اسم العميل أو المورد"), backgroundColor: Colors.orange),
      );
      return;
    }

    final double openingBalance = double.tryParse(_openingBalanceController.text) ?? 0.0;

    final contact = ContactModel(
      id: '', // سيتم توليد الـ ID في قاعدة البيانات
      name: name,
      phone: _phoneController.text.trim(),
      taxNumber: _taxNumberController.text.trim(),
      openingBalance: openingBalance,
      currentBalance: openingBalance,
      type: _selectedType,
    );

    context.read<ContactCubit>().addContact(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(_selectedType == 'customer' ? "إضافة عميل جديد" : "إضافة مورد جديد",
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: AppColors.cardBg,
        elevation: 0.5,
      ),
      body: BlocConsumer<ContactCubit, ContactState>(
        listener: (context, state) {
          if (state is ContactSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم حفظ جهة الاتصال بنجاح"), backgroundColor: Colors.green),
            );
            // العودة للصفحة السابقة وإخبارها بنجاح العملية للتحديث
            Navigator.pop(context, true);
          } else if (state is ContactError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.errorRed),
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is ContactLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeSelector(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("البيانات الأساسية"),
                  _buildTextField(label: "الاسم الكامل / اسم المؤسسة", icon: Icons.person_outline, controller: _nameController),
                  _buildTextField(label: "رقم الجوال", icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone, controller: _phoneController),
                  const SizedBox(height: 20),
                  _buildSectionTitle("البيانات المالية والضريبية"),
                  _buildTextField(label: "الرقم الضريبي (اختياري)", icon: Icons.description_outlined, keyboardType: TextInputType.number, controller: _taxNumberController),
                  _buildTextField(label: "الرصيد الافتتاحي", icon: Icons.account_balance_outlined, keyboardType: const TextInputType.numberWithOptions(decimal: true), suffix: "ريال", controller: _openingBalanceController),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saveContact,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("حفظ البيانات",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(child: _typeButton("عميل", 'customer')),
          Expanded(child: _typeButton("مورد", 'supplier')),
        ],
      ),
    );
  }

  Widget _typeButton(String label, String type) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              )),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Text(title, style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, TextEditingController? controller, TextInputType? keyboardType, String? suffix}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          prefixIcon: Icon(icon, color: AppColors.iconGrey, size: 20),
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.cardBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.dividerColor)),
        ),
      ),
    );
  }
}