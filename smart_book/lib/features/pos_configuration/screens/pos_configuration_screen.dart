import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/pos_configuration_cubit.dart';
import '../models/pos_feature.dart';

class PosConfigurationScreen extends StatefulWidget {
  const PosConfigurationScreen({super.key});

  @override
  State<PosConfigurationScreen> createState() => _PosConfigurationScreenState();
}

class _PosConfigurationScreenState extends State<PosConfigurationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PosConfigurationCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تهيئة نقطة البيع')),
      body: BlocBuilder<PosConfigurationCubit, PosConfigurationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'إعداد ميزات نقطة البيع للمنشأة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              const Text(
                'هذه الإعدادات تحدد ما يظهر داخل شاشة POS. لا يختارها الكاشير؛ يحددها مدير النظام بحسب باقة العميل.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text('تجهيز سريع', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PresetChip(
                    label: 'متجر',
                    features: const {PosFeature.barcode, PosFeature.weightScale},
                  ),
                  _PresetChip(
                    label: 'صيدلية',
                    features: const {
                      PosFeature.barcode,
                      PosFeature.batchTracking,
                      PosFeature.expiryTracking,
                      PosFeature.prescription,
                      PosFeature.alternativeMedicine,
                    },
                  ),
                  _PresetChip(
                    label: 'مطعم',
                    features: const {
                      PosFeature.tables,
                      PosFeature.takeaway,
                      PosFeature.delivery,
                      PosFeature.kitchenNotes,
                      PosFeature.splitBill,
                    },
                  ),
                  _PresetChip(
                    label: 'قطع غيار',
                    features: const {PosFeature.barcode, PosFeature.vehicleFitment},
                  ),
                  _PresetChip(
                    label: 'ملابس',
                    features: const {PosFeature.barcode, PosFeature.sizeAndColor},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('الميزات المفعّلة', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...PosFeature.values.map((feature) => Card(
                    elevation: 0,
                    child: SwitchListTile(
                      title: Text(feature.title),
                      subtitle: Text(feature.description),
                      value: state.isEnabled(feature),
                      onChanged: (value) => context
                          .read<PosConfigurationCubit>()
                          .setFeature(feature, value),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final Set<PosFeature> features;

  const _PresetChip({required this.label, required this.features});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.auto_awesome, size: 18),
      onPressed: () => context.read<PosConfigurationCubit>().applyPreset(features),
    );
  }
}
