import 'package:flutter/material.dart';
import 'package:smart_book/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get lang {
    return AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('ar'));
  }
}