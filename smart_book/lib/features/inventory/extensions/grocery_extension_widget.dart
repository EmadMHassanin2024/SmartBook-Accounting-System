//خاص بالملابس أو البقالة: المقاس، اللون، أو الباركود السريع
import 'package:flutter/material.dart';

class GroceryExtensionWidget extends StatelessWidget {
  final TextEditingController sizeController;
  final TextEditingController colorController;

  const GroceryExtensionWidget({
    super.key,
    required this.sizeController,
    required this.colorController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "خصائص إضافية (مقاس / لون)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: sizeController,
                decoration: InputDecoration(
                  labelText: "المقاس (Size)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: colorController,
                decoration: InputDecoration(
                  labelText: "اللون (Color)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}