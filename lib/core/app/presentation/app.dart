import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_locale/app_locale_cubit.dart';
import 'package:flutter_forge/core/app/presentation/blocs/app_theme/app_theme_cubit.dart';
import 'package:flutter_forge/core/di/injection.dart';
import 'package:flutter_forge/core/router/app_router.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/core/theme/theme.dart';
import 'package:flutter_forge/localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:nested/nested.dart';

import 'blocs/app_startup/app_startup_cubit.dart';
import 'global_app_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return GlobalAppProvider(
      child: MultiBlocListener(
        listeners: <SingleChildWidget>[
          BlocListener<AppStartupCubit, AppStartupState>(
            listener:
                (BuildContext _, AppStartupState state) {
              state.when(
                initial: () => _appRouter
                    .replaceAll(<PageRouteInfo<Object?>>[
                  const OnboardingWrapperRoute(),
                ]),
                unAuthenticated: (String? _) => _appRouter
                    .replaceAll(<PageRouteInfo<Object?>>[
                  const LoginRoute()
                ]),
                authenticated: () => _appRouter
                    .replaceAll(<PageRouteInfo<Object?>>[
                  const HomeRoute()
                ]),
              );
            },
          ),
        ],
        child: _AppMaterialRouter(appRouter: _appRouter),
      ),
    );
  }
}

class _AppMaterialRouter extends StatelessWidget {
  const _AppMaterialRouter({required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child:
          BlocSelector<AppThemeCubit, ThemeMode, ThemeMode>(
        selector: (ThemeMode themeMode) => themeMode,
        builder:
            (BuildContext context, ThemeMode themeMode) {
          return BlocSelector<AppLocaleCubit, AppLocale,
              Locale>(
            selector: (AppLocale appLocale) =>
                appLocale.locale,
            builder: (BuildContext context, Locale locale) {
              return MaterialApp.router(
                routerConfig: appRouter.config(),
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: const <LocalizationsDelegate<
                    dynamic>>[
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations
                    .delegate.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}
