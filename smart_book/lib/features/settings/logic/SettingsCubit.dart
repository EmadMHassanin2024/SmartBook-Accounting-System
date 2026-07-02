import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<Locale> {
  // القيمة الافتراضية هي العربية
  SettingsCubit() : super(const Locale('ar'));

  void toggleLanguage() {
    // تبديل اللغة وإرسال الحالة الجديدة
    emit(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
  }
}