import '../models/system_settings_model.dart';

abstract class SystemConfigurationRepository {
  Future<SystemSettingsModel> loadConfiguration();
  Future<void> saveConfiguration(SystemSettingsModel settings);
}