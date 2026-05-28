import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_forge/core/app/presentation/app.dart';
import 'package:flutter_forge/core/di/injection.dart';
import 'package:flutter_forge/core/notifications/notification_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      final WidgetsBinding widgetsBinding =
          WidgetsFlutterBinding.ensureInitialized();

      // ── Splash ─────────────────────────────────────────────────
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      // ── Flutter framework errors ────────────────────────────────
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
      };

      // ── Dependency injection ────────────────────────────────────
      await configureDependencies();

      // ── Notification service ────────────────────────────────────
      getIt<NotificationService>();

      runApp(const App());
    },
    // ── Dart async errors (outside Flutter framework) ─────────────
    (Object error, StackTrace stack) {
      debugPrint('Unhandled error: $error');
      debugPrint('Stack trace: $stack');
      // tODO: send to Crashlytics / Sentry in production
      // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
