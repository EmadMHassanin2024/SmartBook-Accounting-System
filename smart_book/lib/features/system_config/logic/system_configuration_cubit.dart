import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/ business_module.dart';
import '../data/models/core_module.dart';
import '../data/models/feature_module.dart';
import '../data/repositories/SystemConfigurationRepository.dart';
import 'system_configuration_state.dart';

class SystemConfigurationCubit
    extends Cubit<SystemConfigurationState> {
  final SystemConfigurationRepository _repository;

  SystemConfigurationCubit(this._repository)
      : super(SystemConfigurationState.initial());

  //==================================================
  // Company
  //==================================================

  void updateCompanyName(String value) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          companyName: value,
        ),
      ),
    );
  }

  //==================================================
  // Helpers
  //==================================================

  List<T> _toggleItem<T>(
      List<T> items,
      T item,
      ) {
    final list = List<T>.from(items);

    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }

    return list;
  }

  //==================================================
  // Core Modules
  //==================================================

  void toggleCoreModule(CoreModule module) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledCoreModules: _toggleItem(
            state.settings.enabledCoreModules,
            module,
          ),
        ),
      ),
    );
  }

  void enableCoreModule(CoreModule module) {
    if (isCoreModuleEnabled(module)) return;

    final list = List<CoreModule>.from(
      state.settings.enabledCoreModules,
    );

    list.add(module);

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledCoreModules: list,
        ),
      ),
    );
  }

  void disableCoreModule(CoreModule module) {
    final list = List<CoreModule>.from(
      state.settings.enabledCoreModules,
    );

    list.remove(module);

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledCoreModules: list,
        ),
      ),
    );
  }

  bool isCoreModuleEnabled(
      CoreModule module,
      ) {
    return state.settings.enabledCoreModules.contains(module);
  }

  //==================================================
  // Business Modules
  //==================================================

  void toggleBusinessModule(
      BusinessModule module,
      ) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledBusinessModules: _toggleItem(
            state.settings.enabledBusinessModules,
            module,
          ),
        ),
      ),
    );
  }

  void enableBusinessModule(
      BusinessModule module,
      ) {
    if (isBusinessModuleEnabled(module)) return;

    final list = List<BusinessModule>.from(
      state.settings.enabledBusinessModules,
    );

    list.add(module);

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledBusinessModules: list,
        ),
      ),
    );
  }

  void disableBusinessModule(
      BusinessModule module,
      ) {
    final list = List<BusinessModule>.from(
      state.settings.enabledBusinessModules,
    );

    list.remove(module);

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledBusinessModules: list,
        ),
      ),
    );
  }

  bool isBusinessModuleEnabled(
      BusinessModule module,
      ) {
    return state.settings.enabledBusinessModules.contains(module);
  }

  //==================================================
  // Features
  //==================================================

  void toggleFeature(
      FeatureModule feature,
      ) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledFeatures: _toggleItem(
            state.settings.enabledFeatures,
            feature,
          ),
        ),
      ),
    );
  }

  void enableFeature(
      FeatureModule feature,
      ) {
    if (isFeatureEnabled(feature)) return;

    final list = List<FeatureModule>.from(
      state.settings.enabledFeatures,
    );

    list.add(feature);

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledFeatures: list,
        ),
      ),
    );
  }

  void disableFeature(
      FeatureModule feature,
      ) {
    final list = List<FeatureModule>.from(
      state.settings.enabledFeatures,
    );

    list.remove(feature);

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledFeatures: list,
        ),
      ),
    );
  }

  bool isFeatureEnabled(
      FeatureModule feature,
      ) {
    return state.settings.enabledFeatures.contains(feature);
  }

  //==================================================
  // Reset
  //==================================================

  void resetConfiguration() {
    emit(
      SystemConfigurationState.initial(),
    );
  }

  //==================================================
  // Load
  //==================================================

  Future<void> loadConfiguration() async {
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );

    try {
      // سيتم ربطها بالـ API لاحقاً
      // final settings =
      // await _repository.loadConfiguration();

      emit(
        state.copyWith(
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  //==================================================
  // Save
  //==================================================


  Future<void> saveConfiguration() async {
    emit(state.copyWith(isLoading: true));
    try {
      // تأكد من استدعاء مستودع البيانات (Repository) لحفظ الـ state.settings في قاعدة البيانات SQL Server
      await _repository.saveConfiguration(state.settings);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}