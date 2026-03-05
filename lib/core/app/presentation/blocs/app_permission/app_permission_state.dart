part of 'app_permission_cubit.dart';

enum AppPermission {
  camera,
  gallery,
  location,
  locationAlways,
  microphone,
  notification,
  storage;

  bool get isCamera => this == AppPermission.camera;
  bool get isGallery => this == AppPermission.gallery;
  bool get isLocation => this == AppPermission.location;
  bool get isLocationAlways => this == AppPermission.locationAlways;
  bool get isMicrophone => this == AppPermission.microphone;
  bool get isNotification => this == AppPermission.notification;
  bool get isStorage => this == AppPermission.storage;
}

enum AppPermissionStatus {
  initial,
  granted,
  denied,
  permanentlyDenied,
  restricted;

  bool get isInitial => this == AppPermissionStatus.initial;
  bool get isGranted => this == AppPermissionStatus.granted;
  bool get isDenied => this == AppPermissionStatus.denied;
  bool get isPermanentlyDenied => this == AppPermissionStatus.permanentlyDenied;
  bool get isRestricted => this == AppPermissionStatus.restricted;
}

@freezed
abstract class AppPermissionState with _$AppPermissionState {
  const factory AppPermissionState({
    @Default(<AppPermission, AppPermissionStatus>{})
    Map<AppPermission, AppPermissionStatus> statuses,
  }) = _AppPermissionState;
}
