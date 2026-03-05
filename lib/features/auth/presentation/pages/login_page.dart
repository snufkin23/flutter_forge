import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_permission/app_permission_cubit.dart';
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
              BlocSelector<AppPermissionCubit, AppPermissionState, AppPermissionStatus>(
                selector: (AppPermissionState state) =>
                    state.statuses[AppPermission.camera] ?? AppPermissionStatus.initial,
                builder: (
                  BuildContext context,
                  AppPermissionStatus status,
                ) {
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
                  final AppPermissionStatus status =
                      await context.read<AppPermissionCubit>().check(AppPermission.camera);
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
                  final AppPermissionStatus status =
                      await context.read<AppPermissionCubit>().request(AppPermission.camera);

                  if (status.isGranted) {
                    if (!context.mounted) {
                      return;
                    }
                    context.showSuccessSnackbar('Camera granted ✅');
                  } else if (status.isPermanentlyDenied) {
                    if (!context.mounted) {
                      return;
                    }
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
                    if (!context.mounted) {
                      return;
                    }
                    context.showErrorSnackbar(
                      'Camera permission ${status.name}',
                    );
                  }
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Request camera + microphone together
              CustomButton.text(
                label: 'Request Camera + Microphone',
                onPressed: () async {
                  final Map<AppPermission, AppPermissionStatus> results =
                      await context.read<AppPermissionCubit>().requestMultiple(<AppPermission>[
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
                  final AppPermissionStatus status =
                      await context.read<AppPermissionCubit>().request(AppPermission.location);

                  if (status.isGranted) {
                    if (!context.mounted) {
                      return;
                    }
                    context.showSuccessSnackbar('Location granted ✅');
                  } else if (status.isPermanentlyDenied) {
                    if (!context.mounted) {
                      return;
                    }
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
                    if (!context.mounted) {
                      return;
                    }
                    context.showErrorSnackbar(
                      'Location permission ${status.name}',
                    );
                  }
                },
                expanded: true,
              ),
              12.verticalSpace,

              // Check all permissions at once
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
                builder: (
                  BuildContext context,
                  AppPermissionState state,
                ) {
                  return Column(
                    children: AppPermission.values.map(
                      (AppPermission permission) {
                        final AppPermissionStatus status =
                            state.statuses[permission] ?? AppPermissionStatus.initial;
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

              40.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
