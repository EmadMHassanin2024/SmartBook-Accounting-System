import 'package:equatable/equatable.dart';

import '../data/models/system_settings_model.dart';

class SystemConfigurationState extends Equatable {
  final SystemSettingsModel settings;

  final bool isLoading;

  final bool isSaving;

  final String? errorMessage;

  const SystemConfigurationState({
    required this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
  });

  //============================================================
  // Initial
  //============================================================

  factory SystemConfigurationState.initial() {
    return SystemConfigurationState(
      settings: SystemSettingsModel.initial(),
    );
  }

  //============================================================
  // Copy With
  //============================================================

  SystemConfigurationState copyWith({
    SystemSettingsModel? settings,
    bool? isLoading,
    bool? isSaving,


    String? errorMessage,
    bool clearError = false,
  }) {
    return SystemConfigurationState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage:
      clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  //============================================================
  // Equatable
  //============================================================

  @override
  List<Object?> get props => [
    settings,
    isLoading,
    isSaving,
    errorMessage,
  ];
}