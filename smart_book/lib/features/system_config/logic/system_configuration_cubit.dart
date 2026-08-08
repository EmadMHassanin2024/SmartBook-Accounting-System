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

  //============================================================
  // Company
  //============================================================

  /// تحديث اسم الشركة
  void updateCompanyName(String value) {
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          companyName: value,
        ),
      ),
    );
  }

  //============================================================
  // Helpers
  //============================================================

  /// تبديل عنصر داخل قائمة.
  ///
  /// إذا كان العنصر موجودًا يتم حذفه،
  /// وإذا لم يكن موجودًا تتم إضافته.
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

  //============================================================
  // Core Modules
  //============================================================

  /// تفعيل / إلغاء موديول أساسي
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

  /// تفعيل موديول أساسي
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

  /// إلغاء موديول أساسي
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

  /// هل الموديول الأساسي مفعل؟
  bool isCoreModuleEnabled(CoreModule module) {
    return state.settings.enabledCoreModules.contains(module);
  }

  //============================================================
  // Business Modules
  //============================================================

  /// تفعيل / إلغاء نشاط تجاري
  void toggleBusinessModule(BusinessModule module) {
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

  /// تفعيل نشاط تجاري
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

  /// إلغاء نشاط تجاري
  void disableBusinessModule(BusinessModule module) {
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

  /// هل النشاط التجاري مفعل؟
  bool isBusinessModuleEnabled(BusinessModule module) {
    return state.settings.enabledBusinessModules.contains(module);
  }

  //============================================================
  // Features
  //============================================================

  /// تفعيل / إلغاء خاصية إضافية
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

  /// تفعيل خاصية
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

  /// إلغاء خاصية
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

  /// هل الخاصية مفعلة؟
  bool isFeatureEnabled(FeatureModule feature) {
    return state.settings.enabledFeatures.contains(feature);
  }

  //============================================================
  // Reset
  //============================================================

  /// إعادة الإعدادات للوضع الافتراضي
  void resetConfiguration() {
    emit(
      SystemConfigurationState.initial(),
    );
  }

  //============================================================
  // Load
  //============================================================

  /// تحميل إعدادات النظام
  Future<void> loadConfiguration() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );

    try {
      final settings = await _repository.loadConfiguration();

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

  /// حفظ إعدادات النظام
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