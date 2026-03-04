import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/storage/storage.dart';
import 'package:injectable/injectable.dart';

part 'app_locale_state.dart';

@lazySingleton
class AppLocaleCubit extends Cubit<AppLocale> {
  AppLocaleCubit(this._localStorage) : super(AppLocale.en) {
    _loadSavedLocale();
  }
  final LocalStorage _localStorage;

  void _loadSavedLocale() {
    final String? saved = _localStorage.get<String>(StorageKeys.locale);
    emit(AppLocale.fromCode(saved));
  }

  Future<void> setLocale(AppLocale locale) async {
    emit(locale);
    await _localStorage.put<String>(StorageKeys.locale, locale.name);
  }

  Future<void> setEnglish() => setLocale(AppLocale.en);
  Future<void> setNepali() => setLocale(AppLocale.ne);

  Locale get currentLocale => state.locale;
}
