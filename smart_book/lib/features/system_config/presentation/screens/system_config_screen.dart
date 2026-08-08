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
import '../../../pos/logic/pos_cubit.dart'; // (تأكد من تعديل المسار حسب هيكل مشروعك)

class SystemConfigurationScreen extends StatelessWidget {
  const SystemConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إعدادات النظام")),
      // استخدام BlocConsumer للاستماع لحالات الحفظ والنجاح أو الأخطاء
      body: BlocConsumer<SystemConfigurationCubit, SystemConfigurationState>(
        listener: (context, state) {
          // يمكنك هنا التحقق إذا تم الحفظ بنجاح (حسب ما يتم تنظيمه في SystemConfigurationState لديك)
          // مثلاً إذا أردت تطبيقها فور ضغط الحفظ أو عند انتهاء حالة الـ saving:
        },
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // اسم الشركة
              TextField(
                decoration: const InputDecoration(labelText: "اسم الشركة"),
                onChanged: (val) => context.read<SystemConfigurationCubit>().updateCompanyName(val),
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
            // 1. التقاط الـ Cubit مسبقاً قبل أي عمليات غير متزامنة لتجنب مشاكل الـ Context
            final configCubit = context.read<SystemConfigurationCubit>();

            // 2. تنفيذ الحفظ في الخلفية
            await configCubit.saveConfiguration();

            // 3. التحقق من أن الـ Widget لا تزال نشطة في الشجرة
            if (!context.mounted) return;

            // 4. تطبيق الإعدادات على الـ POS (تأكد من وجود PosCubit في السياق، أو احذفها إن لم تكن مطلوبة هنا مباشرة)
            try {
              final currentSettings = configCubit.state.settings;
              context.read<PosCubit>().applySettingsExtension(currentSettings);
            } catch (_) {
              // لتجنب انهيار التطبيق لو لم يكن الـ PosCubit مُحَقناً في هذه الشاشة
            }

            // 5. إظهار رسالة النجاح والرجوع للصفحة السابقة بأمان
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم حفظ وتطبيق الإعدادات بنجاح"),
                backgroundColor: Colors.green,
              ),
            );

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // إذا لم تكن هناك صفحة سابقة للرجوع إليها، يمكنك الانتقال للصفحة الرئيسية بدلاً من الانهيار
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