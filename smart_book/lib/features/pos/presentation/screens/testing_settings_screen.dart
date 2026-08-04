/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_extension/pharmacy/pharmacy_extension.dart';
import '../../business_extension/restaurant/restaurant_extension.dart';
import '../../logic/pos_cubit.dart';


class TestingSettingsScreen extends StatelessWidget {
  const TestingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اختبار نشاط النظام")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<PosCubit>().setBusinessExtension(PharmacyExtension());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تفعيل وضع الصيدلية")));
              },
              child: const Text("تفعيل الصيدلية"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<PosCubit>().setBusinessExtension(RestaurantExtension());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تفعيل وضع المطعم")));
              },
              child: const Text("تفعيل المطعم"),
            ),
          ],
        ),
      ),
    );
  }
}

 */