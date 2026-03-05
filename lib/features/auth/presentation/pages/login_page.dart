import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_permission/app_permission_cubit.dart';
import 'package:flutter_forge/core/app/presentation/blocs/notification/notification_cubit.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/extensions/context_ui_extension.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';
import 'package:flutter_forge/core/widgets/widgets.dart';
import 'package:flutter_forge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Color _statusColor(AppPermissionStatus status) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green;
      case AppPermissionStatus.denied:
        return Colors.orange;
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red;
      case AppPermissionStatus.restricted:
        return Colors.red;
      case AppPermissionStatus.initial:
        return Colors.grey;
    }
  }

  IconData _statusIcon(AppPermissionStatus status) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Icons.check_circle_rounded;
      case AppPermissionStatus.denied:
        return Icons.cancel_rounded;
      case AppPermissionStatus.permanentlyDenied:
        return Icons.block_rounded;
      case AppPermissionStatus.restricted:
        return Icons.lock_rounded;
      case AppPermissionStatus.initial:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, bool>(
      listener: (BuildContext context, bool loggedIn) {
        if (loggedIn) {
          context.router.replace(const HomeRoute());
        }
      },
      child: CustomScaffold(
        showAppBar: true,
        title: 'flutter_forge',
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              24.verticalSpace,

              // ──────────────────────────────────────────────────
              // Auth
              // ──────────────────────────────────────────────────
              Text('Auth', style: AppTextStyles.titleMedium),
              12.verticalSpace,

              CustomButton.text(
                label: 'Login',
                onPressed: () => context.read<LoginCubit>().login(),
                expanded: true,
              ),
              12.verticalSpace,

              CustomOutlinedButton.text(
                label: 'Confirm Bottom Sheet',
                onPressed: () => context.showConfirmBottomSheet(
                  title: 'Confirm Bottom Sheet',
                  message: 'Are you sure to confirm Bottom Sheet',
                ),
                expanded: true,
              ),
              12.verticalSpace,

              CustomTextFormField.email(
                hintText: 'Hecker',
                label: 'Hecker Man',
              ),
              24.verticalSpace,

              // ──────────────────────────────────────────────────
              // Permissions
              // ──────────────────────────────────────────────────
              Text('Permissions', style: AppTextStyles.titleMedium),
              12.verticalSpace,

              // Camera status indicator — reactive
              BlocSelector<AppPermissionCubit, AppPermissionState,
                  AppPermissionStatus>(
                selector: (AppPermissionState state) =>
                    state.statuses[AppPermission.camera] ??
                    AppPermissionStatus.initial,
                builder: (BuildContext context, AppPermissionStatus status) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: _statusColor(status)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          _statusIcon(status),
                          color: _statusColor(status),
                          size: AppSizes.iconMd,
                        ),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          'Camera: ${status.name}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _statusColor(status),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              12.verticalSpace,

              // Check camera silently
              CustomOutlinedButton.text(
                label: 'Check Camera Status',
                onPressed: () async {
                  final AppPermissionStatus status = await context
                      .read<AppPermissionCubit>()
                      .check(AppPermission.camera);
                  if (!context.mounted) {
                    return;
                  }
                  context.showInfoSnackbar('Camera: ${status.name}');
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Request camera
              CustomButton.text(
                label: 'Request Camera',
                onPressed: () async {
                  final AppPermissionStatus status = await context
                      .read<AppPermissionCubit>()
                      .request(AppPermission.camera);
                  if (!context.mounted) {
                    return;
                  }
                  if (status.isGranted) {
                    context.showSuccessSnackbar('Camera granted ✅');
                  } else if (status.isPermanentlyDenied) {
                    final bool? open = await context.showConfirmDialog(
                      title: 'Camera Permission',
                      message: 'Camera is permanently denied. Open settings?',
                    );
                    if (open == true) {
                      if (!context.mounted) {
                        return;
                      }
                      await context.read<AppPermissionCubit>().openSettings();
                    }
                  } else {
                    context.showErrorSnackbar(
                      'Camera permission ${status.name}',
                    );
                  }
                },
                expanded: true,
              ),
              // Request Gallery
              12.verticalSpace,

              CustomButton.text(
                label: 'Request Gallery',
                onPressed: () async {
                  final AppPermissionStatus status = await context
                      .read<AppPermissionCubit>()
                      .request(AppPermission.gallery);
                  if (!context.mounted) {
                    return;
                  }
                  if (status.isGranted) {
                    context.showSuccessSnackbar('Gallery access granted ✅');
                  } else if (status.isPermanentlyDenied) {
                    final bool? open = await context.showConfirmDialog(
                      title: 'Gallery Permission',
                      message: 'Gallery is permanently denied. Open settings?',
                    );
                    if (open == true) {
                      if (!context.mounted) {
                        return;
                      }
                      await context.read<AppPermissionCubit>().openSettings();
                    }
                  } else {
                    context.showErrorSnackbar(
                      'Gallery permission ${status.name}',
                    );
                  }
                },
                expanded: true,
              ),
              12.verticalSpace,
              // Request camera + microphone
              CustomButton.text(
                label: 'Request Camera + Microphone',
                onPressed: () async {
                  final Map<AppPermission, AppPermissionStatus> results =
                      await context
                          .read<AppPermissionCubit>()
                          .requestMultiple(<AppPermission>[
                    AppPermission.camera,
                    AppPermission.microphone,
                  ]);
                  final StringBuffer buffer = StringBuffer();
                  results.forEach(
                    (AppPermission p, AppPermissionStatus s) =>
                        buffer.write('${p.name}: ${s.name}  '),
                  );
                  if (!context.mounted) {
                    return;
                  }
                  context.showInfoSnackbar(buffer.toString());
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Request location
              CustomButton.text(
                label: 'Request Location',
                onPressed: () async {
                  final AppPermissionStatus status = await context
                      .read<AppPermissionCubit>()
                      .request(AppPermission.location);
                  if (!context.mounted) {
                    return;
                  }
                  if (status.isGranted) {
                    context.showSuccessSnackbar('Location granted ✅');
                  } else if (status.isPermanentlyDenied) {
                    final bool? open = await context.showConfirmDialog(
                      title: 'Location Permission',
                      message: 'Location is permanently denied. Open settings?',
                    );
                    if (open == true) {
                      if (!context.mounted) {
                        return;
                      }
                      await context.read<AppPermissionCubit>().openSettings();
                    }
                  } else {
                    context.showErrorSnackbar(
                      'Location permission ${status.name}',
                    );
                  }
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Check all permissions
              CustomOutlinedButton.text(
                label: 'Check All Permissions',
                onPressed: () async {
                  await context.read<AppPermissionCubit>().checkAll();
                  if (!context.mounted) {
                    return;
                  }
                  context.showInfoSnackbar('All permissions checked');
                },
                expanded: true,
              ),
              12.verticalSpace,

              // All permissions status — reactive
              BlocBuilder<AppPermissionCubit, AppPermissionState>(
                builder: (BuildContext context, AppPermissionState state) {
                  return Column(
                    children: AppPermission.values.map(
                      (AppPermission permission) {
                        final AppPermissionStatus status =
                            state.statuses[permission] ??
                                AppPermissionStatus.initial;
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppSizes.xs),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                _statusIcon(status),
                                color: _statusColor(status),
                                size: AppSizes.iconSm,
                              ),
                              SizedBox(width: AppSizes.sm),
                              Text(
                                '${permission.name}: ${status.name}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: _statusColor(status),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
              24.verticalSpace,

              // ──────────────────────────────────────────────────
              // Notifications
              // ──────────────────────────────────────────────────
              Text('Notifications', style: AppTextStyles.titleMedium),
              12.verticalSpace,

              // Notification status indicator — reactive
              BlocSelector<NotificationCubit, NotificationState,
                  NotificationStatus>(
                selector: (NotificationState state) => state.status,
                builder: (BuildContext context, NotificationStatus status) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: status == NotificationStatus.enabled
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: status == NotificationStatus.enabled
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          status == NotificationStatus.enabled
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_off_rounded,
                          color: status == NotificationStatus.enabled
                              ? Colors.green
                              : Colors.grey,
                          size: AppSizes.iconMd,
                        ),
                        SizedBox(width: AppSizes.sm),
                        Text(
                          'Notifications: ${status.name}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: status == NotificationStatus.enabled
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              12.verticalSpace,

              // Check notification status
              CustomOutlinedButton.text(
                label: 'Check Notification Status',
                onPressed: () async {
                  await context.read<NotificationCubit>().checkStatus();
                  if (!context.mounted) {
                    return;
                  }
                  final NotificationStatus status =
                      context.read<NotificationCubit>().state.status;
                  context.showInfoSnackbar(
                    'Notifications: ${status.name}',
                  );
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Show instantly
              BlocSelector<NotificationCubit, NotificationState, bool>(
                selector: (NotificationState state) => state.isLoading,
                builder: (BuildContext context, bool isLoading) {
                  return CustomButton.text(
                    label: 'Show Now',
                    isLoading: isLoading,
                    onPressed: () async {
                      await context.read<NotificationCubit>().showNow(
                            id: 0,
                            title: 'Hello 👋',
                            body: 'This is an instant notification',
                          );
                      if (!context.mounted) {
                        return;
                      }
                      context.showSuccessSnackbar('Notification sent!');
                    },
                    expanded: true,
                  );
                },
              ),
              12.verticalSpace,

              // Show after 5 seconds
              CustomButton.text(
                label: 'Show in 5 seconds',
                onPressed: () async {
                  await context.read<NotificationCubit>().scheduleAt(
                        id: 2,
                        title: 'Delayed 🕐',
                        body: 'This appeared 5 seconds later',
                        scheduledDate:
                            DateTime.now().add(const Duration(seconds: 5)),
                      );
                  if (!context.mounted) {
                    return;
                  }
                  context.showInfoSnackbar(
                    'Notification coming in 5s — lock screen!',
                  );
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Show after 10 seconds
              CustomButton.text(
                label: 'Show in 10 seconds',
                onPressed: () async {
                  await context.read<NotificationCubit>().scheduleAt(
                        id: 3,
                        title: 'Delayed 🕐',
                        body: 'This appeared 10 seconds later',
                        scheduledDate:
                            DateTime.now().add(const Duration(seconds: 10)),
                      );
                  if (!context.mounted) {
                    return;
                  }
                  context.showInfoSnackbar(
                    'Notification coming in 10s — lock screen!',
                  );
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Pending notifications count — reactive
              BlocSelector<NotificationCubit, NotificationState, int>(
                selector: (NotificationState state) => state.pending.length,
                builder: (BuildContext context, int count) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Text(
                      'Pending notifications: $count',
                      style: AppTextStyles.bodyMedium,
                    ),
                  );
                },
              ),
              12.verticalSpace,

              // Refresh pending
              CustomOutlinedButton.text(
                label: 'Refresh Pending',
                onPressed: () async {
                  await context.read<NotificationCubit>().refreshPending();
                  if (!context.mounted) {
                    return;
                  }
                  final int count =
                      context.read<NotificationCubit>().state.pending.length;
                  context.showInfoSnackbar('Pending: $count');
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Cancel all
              CustomOutlinedButton.text(
                label: 'Cancel All Notifications',
                onPressed: () async {
                  await context.read<NotificationCubit>().cancelAll();
                  if (!context.mounted) {
                    return;
                  }
                  context.showSuccessSnackbar('All notifications cancelled');
                },
                expanded: true,
              ),

              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
