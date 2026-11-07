
class SystemSettingsState {
  final bool isInventoryEnabled;
  final bool isPosEnabled;
  final bool isAccountingEnabled;
  final String businessType; // نوع النشاط (تجزئة، خدمات، إلخ)

  SystemSettingsState({
    this.isInventoryEnabled = true,
    this.isPosEnabled = true,
    this.isAccountingEnabled = true,
    this.businessType = 'retail',
  });

  SystemSettingsState copyWith({
    bool? isInventoryEnabled,
    bool? isPosEnabled,
    bool? isAccountingEnabled,
    String? businessType,
  }) {
    return SystemSettingsState(
      isInventoryEnabled: isInventoryEnabled ?? this.isInventoryEnabled,
      isPosEnabled: isPosEnabled ?? this.isPosEnabled,
      isAccountingEnabled: isAccountingEnabled ?? this.isAccountingEnabled,
      businessType: businessType ?? this.businessType,
    );
  }
}