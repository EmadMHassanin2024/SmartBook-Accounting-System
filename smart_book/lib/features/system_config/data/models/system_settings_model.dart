import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import ' business_module.dart';
import 'core_module.dart';
import 'feature_module.dart';

@immutable
class SystemSettingsModel extends Equatable {
  final String companyName;
  final List<CoreModule> enabledCoreModules;
  final List<BusinessModule> enabledBusinessModules;
  final List<FeatureModule> enabledFeatures;

  const SystemSettingsModel({
    required this.companyName,
    required this.enabledCoreModules,
    required this.enabledBusinessModules,
    required this.enabledFeatures,
  });

  factory SystemSettingsModel.initial() {
    return const SystemSettingsModel(
      companyName: "",
      enabledCoreModules: [
        CoreModule.pos,
        CoreModule.sales,
        CoreModule.inventory,
      ],
      enabledBusinessModules: [
        BusinessModule.generalStore,
      ],
      enabledFeatures: [
        FeatureModule.barcodeScanner,
      ],
    );
  }

  bool hasCoreModule(CoreModule module) {
    return enabledCoreModules.contains(module);
  }

  bool hasBusinessModule(BusinessModule module) {
    return enabledBusinessModules.contains(module);
  }

  bool hasFeature(FeatureModule feature) {
    return enabledFeatures.contains(feature);
  }

  SystemSettingsModel copyWith({
    String? companyName,
    List<CoreModule>? enabledCoreModules,
    List<BusinessModule>? enabledBusinessModules,
    List<FeatureModule>? enabledFeatures,
  }) {
    return SystemSettingsModel(
      companyName: companyName ?? this.companyName,
      enabledCoreModules: enabledCoreModules ?? this.enabledCoreModules,
      enabledBusinessModules:
      enabledBusinessModules ?? this.enabledBusinessModules,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
    );
  }

  // تحويل البيانات للإرسال إلى السيرفر
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'enabledCoreModules': enabledCoreModules.map((e) => e.name).toList(),
      'enabledBusinessModules': enabledBusinessModules.map((e) => e.name).toList(),
      'enabledFeatures': enabledFeatures.map((e) => e.name).toList(),
    };
  }

  // استقبال البيانات وتحويلها من السيرفر إلى Enums
  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      companyName: json['companyName'] ?? '',
      enabledCoreModules: (json['enabledCoreModules'] as List<dynamic>?)
          ?.map((e) => CoreModule.values.byName(e.toString()))
          .toList() ??
          [],
      enabledBusinessModules: (json['enabledBusinessModules'] as List<dynamic>?)
          ?.map((e) => BusinessModule.values.byName(e.toString()))
          .toList() ??
          [],
      enabledFeatures: (json['enabledFeatures'] as List<dynamic>?)
          ?.map((e) => FeatureModule.values.byName(e.toString()))
          .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
    companyName,
    enabledCoreModules,
    enabledBusinessModules,
    enabledFeatures,
  ];
}