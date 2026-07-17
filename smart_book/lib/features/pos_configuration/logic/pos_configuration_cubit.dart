import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pos_feature.dart';

class PosConfigurationState extends Equatable {
  final Set<PosFeature> enabledFeatures;
  final bool isLoading;

  const PosConfigurationState({
    this.enabledFeatures = const {PosFeature.barcode},
    this.isLoading = false,
  });

  bool isEnabled(PosFeature feature) => enabledFeatures.contains(feature);

  PosConfigurationState copyWith({
    Set<PosFeature>? enabledFeatures,
    bool? isLoading,
  }) => PosConfigurationState(
        enabledFeatures: enabledFeatures ?? this.enabledFeatures,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [enabledFeatures, isLoading];
}

class PosConfigurationCubit extends Cubit<PosConfigurationState> {
  PosConfigurationCubit() : super(const PosConfigurationState());

  static const _storageKey = 'enabled_pos_features';

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final preferences = await SharedPreferences.getInstance();
    final savedNames = preferences.getStringList(_storageKey);
    final enabled = savedNames == null
        ? <PosFeature>{PosFeature.barcode}
        : savedNames
            .map((name) => PosFeature.values.where((item) => item.name == name))
            .where((matches) => matches.isNotEmpty)
            .map((matches) => matches.first)
            .toSet();
    emit(PosConfigurationState(enabledFeatures: enabled));
  }

  Future<void> setFeature(PosFeature feature, bool enabled) async {
    final features = Set<PosFeature>.from(state.enabledFeatures);
    enabled ? features.add(feature) : features.remove(feature);
    await _save(features);
  }

  Future<void> applyPreset(Set<PosFeature> features) => _save(features);

  Future<void> _save(Set<PosFeature> features) async {
    emit(state.copyWith(enabledFeatures: features));
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      features.map((feature) => feature.name).toList(),
    );
  }
}
