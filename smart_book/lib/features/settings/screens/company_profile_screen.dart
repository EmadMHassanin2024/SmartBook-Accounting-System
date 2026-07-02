import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إعدادات المنشأة")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // اختيار الشعار
            Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: Colors.grey[200], child: const Icon(Icons.add_a_photo, size: 30)),
                  const TextButton(onPressed: null, child: Text("رفع شعار المنشأة")),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("الاسم التجاري (عربي)", Icons.business),
            _buildTextField("الاسم التجاري (English)", Icons.translate),
            _buildTextField("الرقم الضريبي (15 رقم)", Icons.confirmation_number, isTax: true),
            _buildTextField("العنوان", Icons.location_on),
            _buildTextField("رقم الهاتف", Icons.phone),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: AppColors.primaryBlue),
              onPressed: () {},
              child: const Text("حفظ البيانات", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool isTax = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          counterText: isTax ? "0/15" : null,
        ),
      ),
    );
  }
}