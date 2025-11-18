import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  // Vietnamese as the default language
  LanguageCubit() : super(const Locale('vi'));

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
  }
}