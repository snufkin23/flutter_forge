import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_locale/app_locale_cubit.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_permission/app_permission_cubit.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_startup/app_startup_cubit.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_theme/app_theme_cubit.dart';
import 'package:flutter_forge/core/app/presentation/blocs/notification/notification_cubit.dart';
import 'package:flutter_forge/core/di/injection.dart';
import 'package:flutter_forge/core/storage/local_storage.dart';
import 'package:flutter_forge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_forge/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nested/nested.dart';

class GlobalAppProvider extends StatelessWidget {
  const GlobalAppProvider({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AppStartupCubit>(
          create: (_) => AppStartupCubit(getIt<LocalStorage>()),
        ),
        BlocProvider<AppThemeCubit>(
          create: (_) => AppThemeCubit(getIt<LocalStorage>()),
        ),
        BlocProvider<AppLocaleCubit>(
          create: (_) => AppLocaleCubit(getIt<LocalStorage>()),
        ),
        BlocProvider<AppPermissionCubit>(create: (_) => AppPermissionCubit()),
        BlocProvider<NotificationCubit>(
          create: (_) => getIt<NotificationCubit>(),
        ),
        BlocProvider<OnboardingCubit>(
          create: (_) => OnboardingCubit(getIt<LocalStorage>())..checkStatus(),
        ),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
      ],
      child: child,
    );
  }
}
