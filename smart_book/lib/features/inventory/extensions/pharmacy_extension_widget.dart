import 'package:flutter/material.dart';

class PharmacyExtensionWidget extends StatelessWidget {
  final TextEditingController expiryController;
  final TextEditingController batchController;
  final VoidCallback onSelectExpiry;

  const PharmacyExtensionWidget({
    super.key,
    required this.expiryController,
    required this.batchController,
    required this.onSelectExpiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "خصائص الصيدلية",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // تاريخ الصلاحية
              Expanded(
                child: TextFormField(
                  controller: expiryController,
                  readOnly: true,
                  onTap: onSelectExpiry,
                  decoration: InputDecoration(
                    hintText: "تاريخ الصلاحية",
                    prefixIcon: const Icon(Icons.calendar_today, size: 20, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // رقم التشغيلة
              Expanded(
                child: TextFormField(
                  controller: batchController,
                  decoration: InputDecoration(
                    hintText: "رقم التشغيلة",
                    prefixIcon: const Icon(Icons.qr_code, size: 20, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}