import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/constants/app_constants.dart';
import 'package:flutter_forge/core/storage/local_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_startup_cubit.freezed.dart';
part 'app_startup_state.dart';

/// AppStartupCubit is responsible for **deciding the first screen** on app launch:
/// - Shows onboarding/login if the user is unauthenticated
/// - Shows home if the user is already authenticated
/// It keeps the **native splash visible** until the decision is made.
///
@injectable
class AppStartupCubit extends Cubit<AppStartupState> {
  AppStartupCubit(this._storage) : super(const _Initial()) {
    _init();
  }
  final LocalStorage _storage;

  /// Initializes the app: checks session and decides first screen
  ///
  Future<void> _init() async {
    await Future<void>.microtask(() async {
      final bool hasOnboarded =
          _storage.get<bool>(AppConstants.onboardingKey) ?? false;
      if (hasOnboarded) {
        emit(const _UnAuthenticated());
      }
      FlutterNativeSplash.remove();
    });
  }
}
