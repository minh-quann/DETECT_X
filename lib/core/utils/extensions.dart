import 'package:detect_x/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  // Getter for localized strings
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  // Getter for locale
  Locale get locale => Localizations.localeOf(this);
}
