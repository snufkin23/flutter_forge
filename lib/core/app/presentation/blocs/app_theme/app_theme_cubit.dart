import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/constants/constants.dart';
import 'package:flutter_forge/core/storage/storage.dart';
import 'package:injectable/injectable.dart';

part 'app_theme_state.dart';

@lazySingleton
class AppThemeCubit extends Cubit<ThemeMode> {
  AppThemeCubit(this._localStorage) : super(AppThemeState.initial()) {
    _loadSavedTheme();
  }
  final LocalStorage _localStorage;

  void _loadSavedTheme() {
    final String? saved = _localStorage.get<String>(StorageKeys.themeMode);
    emit(AppThemeState.fromString(saved));
  }

  Future<void> toggle() {
    final ThemeMode next = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    return setMode(next);
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(mode);
    await _localStorage.put<String>(
      StorageKeys.themeMode,
      AppThemeState.asString(mode),
    );
  }
}
