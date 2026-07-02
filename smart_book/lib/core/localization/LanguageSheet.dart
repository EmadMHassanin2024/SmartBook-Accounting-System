import 'package:flutter/material.dart';


import '../../main.dart'; // ⬅️ مهم: للوصول إلى appLocale

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('العربية'),
            onTap: () => _changeLanguage('ar', context),
          ),
          ListTile(
            title: const Text('English'),
            onTap: () => _changeLanguage('en', context),
          ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(String code, BuildContext context) async {
    /// ✅ تغيير اللغة Runtime
    appLocale.value = Locale(code);

    /// ✅ حفظ اللغة
   // final prefs = await SharedPreferences.getInstance();
 //   await prefs.setString('lang', code);

    Navigator.pop(context);
  }
}
