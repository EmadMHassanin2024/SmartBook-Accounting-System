import 'package:flutter/material.dart';

class POSProductsError extends StatelessWidget {
  final String message;
  const POSProductsError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }
}