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

  final BusinessModule activeBusinessModule;

  final List<FeatureModule> enabledFeatures;

  const SystemSettingsModel({
    required this.companyName,
    required this.enabledCoreModules,
    required this.enabledBusinessModules,
    required this.activeBusinessModule,
    required this.enabledFeatures,
  });


  factory SystemSettingsModel.initial() {
    return const SystemSettingsModel(
      companyName: '',
      enabledCoreModules: [
        CoreModule.pos,
        CoreModule.sales,
        CoreModule.inventory,
      ],
      enabledBusinessModules: [
        BusinessModule.generalStore,
      ],
      activeBusinessModule: BusinessModule.generalStore,
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
    BusinessModule? activeBusinessModule,
    List<FeatureModule>? enabledFeatures,
  }) {
    return SystemSettingsModel(
      companyName: companyName ?? this.companyName,
      enabledCoreModules:
      enabledCoreModules ?? this.enabledCoreModules,
      enabledBusinessModules:
      enabledBusinessModules ?? this.enabledBusinessModules,
      activeBusinessModule:
      activeBusinessModule ?? this.activeBusinessModule,
      enabledFeatures:
      enabledFeatures ?? this.enabledFeatures,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,

      'enabledCoreModules':
      enabledCoreModules.map((e) => e.name).toList(),

      'enabledBusinessModules':
      enabledBusinessModules.map((e) => e.name).toList(),

      'activeBusinessModule':
      activeBusinessModule.name,

      'enabledFeatures':
      enabledFeatures.map((e) => e.name).toList(),
    };
  }



  factory SystemSettingsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final enabledBusinessModules =
        (json['enabledBusinessModules'] as List<dynamic>?)
            ?.map(
              (e) => BusinessModule.values.byName(
            e.toString(),
          ),
        )
            .toList() ??
            [];

    final activeBusinessModule =
    json['activeBusinessModule'] != null
        ? BusinessModule.values.byName(
      json['activeBusinessModule'].toString(),
    )
        : enabledBusinessModules.isNotEmpty
        ? enabledBusinessModules.first
        : BusinessModule.generalStore;

    return SystemSettingsModel(
      companyName: json['companyName'] ?? '',

      enabledCoreModules:
      (json['enabledCoreModules'] as List<dynamic>?)
          ?.map(
            (e) => CoreModule.values.byName(
          e.toString(),
        ),
      )
          .toList() ??
          [],

      enabledBusinessModules:
      enabledBusinessModules,

      activeBusinessModule:
      activeBusinessModule,

      enabledFeatures:
      (json['enabledFeatures'] as List<dynamic>?)
          ?.map(
            (e) => FeatureModule.values.byName(
          e.toString(),
        ),
      )
          .toList() ??
          [],
    );
  }


  @override
  List<Object?> get props => [
    companyName,
    enabledCoreModules,
    enabledBusinessModules,
    activeBusinessModule,
    enabledFeatures,
  ];
}