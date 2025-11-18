// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'AI Detector';

  @override
  String get loginTitle => 'Deepfake Detector';

  @override
  String get loginSubtitle => 'Bảo vệ sự thật trong kỷ nguyên AI';

  @override
  String get emailLabel => 'Địa chỉ Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get guestButton => 'Dùng thử (Không cần tài khoản)';

  @override
  String get emailErrorEmpty => 'Vui lòng nhập Email';

  @override
  String get emailErrorInvalid => 'Email không hợp lệ';

  @override
  String get passwordErrorShort => 'Mật khẩu phải trên 6 ký tự';

  @override
  String get errorLogin => 'Đăng nhập thất bại';

  @override
  String get settingsLanguage => 'Ngôn ngữ';
}
