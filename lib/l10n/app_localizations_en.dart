// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI Detector';

  @override
  String get loginTitle => 'Deepfake Detector';

  @override
  String get loginSubtitle => 'Protect truth in the AI era';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get guestButton => 'Try as Guest (No Account)';

  @override
  String get emailErrorEmpty => 'Please enter your email';

  @override
  String get emailErrorInvalid => 'Invalid email format';

  @override
  String get passwordErrorShort => 'Password must be at least 6 characters';

  @override
  String get errorLogin => 'Login Failed';

  @override
  String get settingsLanguage => 'Language';
}
