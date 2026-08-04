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

  factory SystemConfigurationState.initial() {

    return SystemConfigurationState(

      settings: SystemSettingsModel.initial(),

    );

  }

  SystemConfigurationState copyWith({

    SystemSettingsModel? settings,

    bool? isLoading,

    bool? isSaving,

    String? errorMessage,

  }) {

    return SystemConfigurationState(

      settings: settings ?? this.settings,

      isLoading: isLoading ?? this.isLoading,

      isSaving: isSaving ?? this.isSaving,

      errorMessage: errorMessage,

    );

  }

  @override
  List<Object?> get props => [

    settings,

    isLoading,

    isSaving,

    errorMessage,

  ];
}