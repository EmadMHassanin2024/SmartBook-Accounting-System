import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/JournalDetailModel.dart';


// المكون الأول: حقول رأس القيد
class JournalHeaderSection extends StatelessWidget {
  final TextEditingController refController;
  final TextEditingController descController;
  final DateTime selectedDate;
  final VoidCallback onPickDate;

  const JournalHeaderSection({
    super.key,
    required this.refController,
    required this.descController,
    required this.selectedDate,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: refController,
                  decoration: const InputDecoration(labelText: "رقم المرجع", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: onPickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: "التاريخ", border: OutlineInputBorder()),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: descController,
            decoration: const InputDecoration(labelText: "البيان العام للقيد", border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }
}



