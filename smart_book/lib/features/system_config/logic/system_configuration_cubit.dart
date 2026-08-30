import 'package:flutter_bloc/flutter_bloc.dart';


import '../data/models/ business_module.dart';
import '../data/models/core_module.dart';
import '../data/models/feature_module.dart';
import '../data/repositories/SystemConfigurationRepository.dart';
import '../data/repositories/system_configuration_repository.dart';
import 'system_configuration_state.dart';

class SystemConfigurationCubit
    extends Cubit<SystemConfigurationState> {
  final SystemConfigurationRepository _repository;

  SystemConfigurationCubit(this._repository)
      : super(SystemConfigurationState.initial());


  void updateCompanyName(String value) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          companyName: value,
        ),
      ),
    );
  }


  List<T> _toggleItem<T>(
      List<T> items, T item) {
        final list = List<T>.from(items);

        if (list.contains(item)) {
          list.remove(item);
        } else {
          list.add(item);
    }

    return list;
  }


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
    if (isCoreModuleEnabled(module)) {
      return;
    }

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

  bool isCoreModuleEnabled(CoreModule module) {
    return state.settings.enabledCoreModules.contains(module);
  }

  //============================================================
  // Business Modules
  //============================================================

  void toggleBusinessModule(BusinessModule module) {
    final currentModules =
        state.settings.enabledBusinessModules;

    // لا يمكن تعطيل النشاط الحالي.
    if (module == state.settings.activeBusinessModule &&
        currentModules.contains(module)) {
      return;
    }

    // يجب أن يبقى نشاط واحد على الأقل.
    if (currentModules.length <= 1 &&
        currentModules.contains(module)) {
      return;
    }

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          enabledBusinessModules: _toggleItem(
            currentModules,
            module,
          ),
        ),
      ),
    );
  }

  void enableBusinessModule(BusinessModule module) {
    if (isBusinessModuleEnabled(module)) {
      return;
    }

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

  void disableBusinessModule(BusinessModule module) {
    final currentModules =
        state.settings.enabledBusinessModules;

    // لا يمكن تعطيل النشاط الحالي.
    if (module == state.settings.activeBusinessModule) {
      return;
    }

    // يجب أن يبقى نشاط واحد على الأقل.
    if (currentModules.length <= 1) {
      return;
    }

    final list = List<BusinessModule>.from(
      currentModules,
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
    return state.settings.enabledBusinessModules
        .contains(module);
  }

  //============================================================
  // Active Business Module
  //============================================================

  /// تغيير النشاط الحالي.
  ///
  /// لا يسمح باختيار نشاط غير مفعّل.
  void setActiveBusinessModule(
      BusinessModule module,
      ) {
    if (!isBusinessModuleEnabled(module)) {
      return;
    }

    if (module == state.settings.activeBusinessModule) {
      return;
    }

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          activeBusinessModule: module,
        ),
      ),
    );
  }

  //============================================================
  // Features
  //============================================================

  void toggleFeature(FeatureModule feature) {
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

  void enableFeature(FeatureModule feature) {
    if (isFeatureEnabled(feature)) {
      return;
    }

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

  void disableFeature(FeatureModule feature) {
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

  bool isFeatureEnabled(FeatureModule feature) {
    return state.settings.enabledFeatures.contains(feature);
  }

  //============================================================
  // Reset
  //============================================================

  void resetConfiguration() {
    emit(
      SystemConfigurationState.initial(),
    );
  }

  //============================================================
  // Load
  //============================================================

  Future<void> loadConfiguration() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      final settings =
      await _repository.loadConfiguration();

      if (settings != null) {
        emit(
          state.copyWith(
            settings: settings,
            isLoading: false,
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: null,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  //============================================================
  // Save
  //============================================================

  Future<void> saveConfiguration() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      await _repository.saveConfiguration(
        state.settings,
      );

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: null,
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
}