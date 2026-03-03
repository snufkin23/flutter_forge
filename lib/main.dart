import 'package:flutter/material.dart';
import 'package:flutter_forge/core/app/presentation/app.dart';
import 'package:flutter_forge/core/di/injection.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await configureDependencies();
  runApp(const App());
}
