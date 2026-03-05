import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_permission/app_permission_cubit.dart';
import 'package:flutter_forge/core/constants/sizes.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/core/theme/app_text_styles.dart';
import 'package:flutter_forge/core/widgets/widgets.dart';
import 'package:flutter_forge/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _syncPage(int page) {
    if (_pageController.hasClients && _pageController.page?.round() != page) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (BuildContext context, OnboardingState state) {
        if (state.isCompleted) {
          context.router.replace(const LoginRoute());
        } else {
          _syncPage(state.currentPage);
        }
      },
      child: CustomScaffold(
        showAppBar: false,
        body: Column(
          children: <Widget>[
            // ── Pages ──────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _WelcomePage(
                    onNext: () => context.read<OnboardingCubit>().nextPage(),
                  ),
                  _PermissionsPage(
                    onNext: () => context.read<OnboardingCubit>().nextPage(),
                  ),
                  _DonePage(
                    onFinish: () => context.read<OnboardingCubit>().completeOnboarding(),
                  ),
                ],
              ),
            ),

            // ── Page indicator ─────────────────────────────────
            BlocSelector<OnboardingCubit, OnboardingState, int>(
              selector: (OnboardingState state) => state.currentPage,
              builder: (BuildContext context, int currentPage) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSizes.xxl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      3,
                      (int index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                          horizontal: AppSizes.xs,
                        ),
                        width: currentPage == index ? 24.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusFull,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page 1: Welcome ───────────────────────────────────────────────
class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.rocket_launch_rounded,
            size: 100.w,
            color: Theme.of(context).colorScheme.primary,
          ),
          32.verticalSpace,
          Text(
            'Welcome to\nFlutter Forge',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLarge,
          ),
          16.verticalSpace,
          Text(
            'A production-ready Flutter template.\nForge every new app from this.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          48.verticalSpace,
          CustomButton.text(
            label: 'Get Started',
            onPressed: onNext,
            expanded: true,
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Permissions ───────────────────────────────────────────
class _PermissionsPage extends StatelessWidget {
  const _PermissionsPage({required this.onNext});

  final VoidCallback onNext;

  static const List<_PermissionItem> _items = <_PermissionItem>[
    _PermissionItem(
      permission: AppPermission.camera,
      icon: Icons.camera_alt_rounded,
      title: 'Camera',
      description: 'Take photos and scan documents',
    ),
    _PermissionItem(
      permission: AppPermission.location,
      icon: Icons.location_on_rounded,
      title: 'Location',
      description: 'Find nearby services',
    ),
    _PermissionItem(
      permission: AppPermission.notification,
      icon: Icons.notifications_rounded,
      title: 'Notifications',
      description: 'Stay updated with latest alerts',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Allow Permissions',
            style: AppTextStyles.headlineMedium,
          ),
          8.verticalSpace,
          Text(
            'We need a few permissions to give you the best experience.',
            style: AppTextStyles.bodyMedium,
          ),
          32.verticalSpace,
          BlocBuilder<AppPermissionCubit, AppPermissionState>(
            builder: (BuildContext context, AppPermissionState state) {
              return Column(
                children: _items
                    .map(
                      (_PermissionItem item) => _PermissionTile(
                        item: item,
                        status: state.statuses[item.permission] ?? AppPermissionStatus.initial,
                        onTap: () async {
                          final AppPermissionStatus result =
                              await context.read<AppPermissionCubit>().request(item.permission);
                          if (result.isPermanentlyDenied) {
                            if (!context.mounted) {
                              return;
                            }
                            await context.read<AppPermissionCubit>().openSettings();
                          }
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
          32.verticalSpace,
          CustomButton.text(
            label: 'Continue',
            onPressed: onNext,
            expanded: true,
          ),
          12.verticalSpace,
          CustomOutlinedButton.text(
            label: 'Skip for now',
            onPressed: onNext,
            expanded: true,
          ),
        ],
      ),
    );
  }
}

// ── Permission tile ───────────────────────────────────────────────
class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.item,
    required this.status,
    required this.onTap,
  });

  final _PermissionItem item;
  final AppPermissionStatus status;
  final VoidCallback onTap;

  Color _color(BuildContext context) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green;
      case AppPermissionStatus.denied:
      case AppPermissionStatus.permanentlyDenied:
      case AppPermissionStatus.restricted:
        return Colors.red;
      case AppPermissionStatus.initial:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _statusIcon() {
    switch (status) {
      case AppPermissionStatus.granted:
        return Icons.check_circle_rounded;
      case AppPermissionStatus.denied:
      case AppPermissionStatus.restricted:
        return Icons.cancel_rounded;
      case AppPermissionStatus.permanentlyDenied:
        return Icons.settings_rounded;
      case AppPermissionStatus.initial:
        return Icons.chevron_right_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status.isGranted ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.md),
        padding: EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: _color(context).withValues(alpha: 0.3),
          ),
          color: _color(context).withValues(alpha: 0.05),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: _color(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                item.icon,
                color: _color(context),
                size: AppSizes.iconMd,
              ),
            ),
            SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.title, style: AppTextStyles.labelLarge),
                  4.verticalSpace,
                  Text(
                    item.description,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              _statusIcon(),
              color: _color(context),
              size: AppSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page 3: Done ──────────────────────────────────────────────────
class _DonePage extends StatelessWidget {
  const _DonePage({required this.onFinish});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_rounded,
            size: 100.w,
            color: Colors.green,
          ),
          32.verticalSpace,
          Text(
            "You're all set!",
            style: AppTextStyles.headlineLarge,
          ),
          16.verticalSpace,
          Text(
            "Everything is ready.\nLet's get started.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          48.verticalSpace,
          CustomButton.text(
            label: 'Go to App',
            onPressed: onFinish,
            expanded: true,
          ),
        ],
      ),
    );
  }
}

// ── Permission item config ────────────────────────────────────────
class _PermissionItem {
  const _PermissionItem({
    required this.permission,
    required this.icon,
    required this.title,
    required this.description,
  });

  final AppPermission permission;
  final IconData icon;
  final String title;
  final String description;
}
