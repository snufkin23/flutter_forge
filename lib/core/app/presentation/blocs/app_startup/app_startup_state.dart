part of 'app_startup_cubit.dart';

@freezed
abstract class AppStartupState with _$AppStartupState {
  const factory AppStartupState.initial() = _Initial;
  const factory AppStartupState.unAuthenticated({String? message}) =
      _UnAuthenticated;
  const factory AppStartupState.authenticated() = _Authenticated;
}
