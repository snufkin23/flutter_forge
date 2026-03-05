import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'app_permission_cubit.freezed.dart';
part 'app_permission_state.dart';

@lazySingleton
class AppPermissionCubit extends Cubit<AppPermissionState> {
  AppPermissionCubit() : super(const AppPermissionState());

  // ── Map AppPermission → permission_handler Permission ─────────
  Permission _toHandler(AppPermission permission) {
    switch (permission) {
      case AppPermission.camera:
        return Permission.camera;
      case AppPermission.gallery:
        return Permission.photos;
      case AppPermission.location:
        return Permission.locationWhenInUse;
      case AppPermission.locationAlways:
        return Permission.locationAlways;
      case AppPermission.microphone:
        return Permission.microphone;
      case AppPermission.notification:
        return Permission.notification;
      case AppPermission.storage:
        return Permission.storage;
    }
  }

  // ── Map PermissionStatus → AppPermissionStatus ────────────────
  AppPermissionStatus _toStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
    }
  }

  // ── Check without requesting ──────────────────────────────────
  Future<AppPermissionStatus> check(AppPermission permission) async {
    final PermissionStatus status = await _toHandler(permission).status;
    final AppPermissionStatus appStatus = _toStatus(status);
    _updateState(permission, appStatus);
    return appStatus;
  }

  // ── Request single permission ─────────────────────────────────
  Future<AppPermissionStatus> request(AppPermission permission) async {
    final PermissionStatus status = await _toHandler(permission).request();
    final AppPermissionStatus appStatus = _toStatus(status);
    _updateState(permission, appStatus);
    return appStatus;
  }

  // ── Request multiple permissions ──────────────────────────────
  Future<Map<AppPermission, AppPermissionStatus>> requestMultiple(
    List<AppPermission> permissions,
  ) async {
    final Map<Permission, PermissionStatus> results =
        await permissions.map(_toHandler).toList().request();

    final Map<AppPermission, AppPermissionStatus> appResults =
        <AppPermission, AppPermissionStatus>{};

    for (final AppPermission appPerm in permissions) {
      final PermissionStatus status = results[_toHandler(appPerm)]!;
      final AppPermissionStatus appStatus = _toStatus(status);
      appResults[appPerm] = appStatus;
      _updateState(appPerm, appStatus);
    }

    return appResults;
  }

  // ── Check all permissions silently ────────────────────────────
  Future<void> checkAll() async {
    for (final AppPermission permission in AppPermission.values) {
      await check(permission);
    }
  }

  // ── Open app settings (for permanentlyDenied) ─────────────────
  Future<void> openSettings() async => openAppSettings();

  // ── Convenience getters ───────────────────────────────────────
  AppPermissionStatus statusOf(AppPermission permission) =>
      state.statuses[permission] ?? AppPermissionStatus.initial;

  bool isGranted(AppPermission permission) => statusOf(permission).isGranted;

  bool isPermanentlyDenied(AppPermission permission) =>
      statusOf(permission).isPermanentlyDenied;

  // ── Internal state update ─────────────────────────────────────
  void _updateState(
    AppPermission permission,
    AppPermissionStatus status,
  ) =>
      emit(
        state.copyWith(
          statuses: <AppPermission, AppPermissionStatus>{
            ...state.statuses,
            permission: status,
          },
        ),
      );
}
