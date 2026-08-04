import 'package:flutter/material.dart';

///--------------------------------------------------------------
/// شارة رقم التشغيلة
///--------------------------------------------------------------
class BatchChip extends StatelessWidget {
  final String batchNumber;

  const BatchChip({
    super.key,
    required this.batchNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(
        Icons.inventory_2_outlined,
        size: 16,
      ),
      label: Text(
        batchNumber,
        style: const TextStyle(fontSize: 11),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

///--------------------------------------------------------------
/// شارة تاريخ الصلاحية
///--------------------------------------------------------------
class ExpiryChip extends StatelessWidget {
  final String expiryDate;
  final bool expired;

  const ExpiryChip({
    super.key,
    required this.expiryDate,
    this.expired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        expired ? Icons.warning : Icons.event,
        color: expired ? Colors.red : Colors.green,
        size: 16,
      ),
      label: Text(
        expiryDate,
        style: TextStyle(
          color: expired ? Colors.red : Colors.green,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}

///--------------------------------------------------------------
/// حالة الدواء
///--------------------------------------------------------------
class MedicineStatusChip extends StatelessWidget {
  final String status;

  const MedicineStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status,
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: Colors.blue.shade50,
      visualDensity: VisualDensity.compact,
    );
  }
}

///--------------------------------------------------------------
/// أيقونة الوصفة الطبية
///--------------------------------------------------------------
class PrescriptionIcon extends StatelessWidget {
  final VoidCallback? onPressed;

  const PrescriptionIcon({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Prescription",
      icon: const Icon(
        Icons.receipt_long,
        color: Colors.teal,
      ),
      onPressed: onPressed,
    );
  }
}

///--------------------------------------------------------------
/// بطاقة صغيرة لعرض معلومة
///--------------------------------------------------------------
class PharmacyInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PharmacyInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Icon(
          icon,
          size: 16,
          color: Colors.grey,
        ),

        const SizedBox(width: 6),

        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),

        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}