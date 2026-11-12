import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/main_layout.dart';
import '../../data/models/ business_module.dart';
import '../../data/models/core_module.dart';
import '../../data/models/feature_module.dart';
import '../../extensions/ business_module_extension.dart';
import '../../extensions/core_module_extension.dart';
import '../../extensions/feature_module_extension.dart';
import '../../logic/system_configuration_cubit.dart';
import '../../logic/system_configuration_state.dart';
import '../../../pos/logic/pos_cubit.dart';

class SystemConfigurationScreen extends StatefulWidget {
  const SystemConfigurationScreen({super.key});

  @override
  State<SystemConfigurationScreen> createState() => _SystemConfigurationScreenState();
}

class _SystemConfigurationScreenState extends State<SystemConfigurationScreen> {
  late final TextEditingController _companyNameController;

  @override
  void initState() {
    super.initState();
    // تهيئة الـ Controller بالقيم الأولية من الـ Cubit
    final currentState = context.read<SystemConfigurationCubit>().state;
    _companyNameController = TextEditingController(text: currentState.settings.companyName);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إعدادات النظام")),
      body: BlocConsumer<SystemConfigurationCubit, SystemConfigurationState>(
        listener: (context, state) {
          // تحديث النص في الـ Controller إذا تغير من الخارج (مثل التحميل لأول مرة)
          if (_companyNameController.text != state.settings.companyName) {
            _companyNameController.text = state.settings.companyName;
          }
        },
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // اسم الشركة (باستخدام الـ Controller المستقر)
              TextField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: "اسم الشركة"),
                onChanged: (val) => context.read<SystemConfigurationCubit>().updateCompanyName(val),
              ),
              const SizedBox(height: 20),
              const Text(
                "النشاط الأساسي للبرنامج",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<BusinessModule>(
                value: state.settings.activeBusinessModule,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: BusinessModule.values.map((module) {
                  return DropdownMenuItem<BusinessModule>(
                    value: module,
                    child: Text(module.arabicName),
                  );
                }).toList(),
                onChanged: (BusinessModule? newModule) {
                  if (newModule != null) {
                    final cubit = context.read<SystemConfigurationCubit>();
                    if (!cubit.isBusinessModuleEnabled(newModule)) {
                      cubit.enableBusinessModule(newModule);
                    }
                    cubit.setActiveBusinessModule(newModule);
                  }
                },
              ),
              const SizedBox(height: 20),
              // قسم الموديولات الأساسية
              _buildSection(
                title: "الموديولات الأساسية",
                items: CoreModule.values,
                isEnabled: (item) => state.settings.hasCoreModule(item as CoreModule),
                onToggle: (item) => context.read<SystemConfigurationCubit>().toggleCoreModule(item as CoreModule),
                getName: (item) => (item as CoreModule).arabicName,
                getIcon: (item) => (item as CoreModule).icon,
              ),

              // قسم أنشطة العمل
              _buildSection(
                title: "أنشطة العمل",
                items: BusinessModule.values,
                isEnabled: (item) => state.settings.hasBusinessModule(item as BusinessModule),
                onToggle: (item) => context.read<SystemConfigurationCubit>().toggleBusinessModule(item as BusinessModule),
                getName: (item) => (item as BusinessModule).arabicName,
                getIcon: (item) => (item as BusinessModule).icon,
              ),

              // قسم الميزات الإضافية
              _buildSection(
                title: "الميزات الإضافية",
                items: FeatureModule.values,
                isEnabled: (item) => state.settings.hasFeature(item as FeatureModule),
                onToggle: (item) => context.read<SystemConfigurationCubit>().toggleFeature(item as FeatureModule),
                getName: (item) => (item as FeatureModule).arabicName,
                getIcon: (item) => (item as FeatureModule).icon,
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            final configCubit = context.read<SystemConfigurationCubit>();

            await configCubit.saveConfiguration();

            if (!context.mounted) return;

            try {
              final currentSettings = configCubit.state.settings;
              context.read<PosCubit>().applySettingsExtension(currentSettings);
            } catch (_) {}

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم حفظ وتطبيق الإعدادات بنجاح"),
                backgroundColor: Colors.green,
              ),
            );

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            }
          },
          child: const Text("حفظ الإعدادات"),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<dynamic> items,
    required bool Function(dynamic) isEnabled,
    required Function(dynamic) onToggle,
    required String Function(dynamic) getName,
    required IconData Function(dynamic) getIcon,
  }) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: items.map((item) => CheckboxListTile(
        title: Text(getName(item)),
        secondary: Icon(getIcon(item)),
        value: isEnabled(item),
        onChanged: (_) => onToggle(item),
      )).toList(),
    );
  }
}