import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/di/injection.dart';
import 'package:flutter_forge/core/router/app_router.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/core/theme/theme.dart';
import 'package:flutter_forge/localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/app_startup_cubit.dart';
import 'global_app_provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return GlobalAppProvider(
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppStartupCubit, AppStartupState>(
            listener: (_, AppStartupState state) {
              state.when(
                initial: () => _appRouter.push(const OnboardingWrapperRoute()),
                unAuthenticated: (String? message) => _appRouter.push(const LoginRoute()),
                authenticated: () => _appRouter.push(const HomeRoute()),
              );
            },
          ),
        ],
        child: MaterialApp.router(
          routerConfig: _appRouter.config(),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.delegate.supportedLocales,
        ),
      ),
    );
  }
}
