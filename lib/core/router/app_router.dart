import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: OnboardingWrapperRoute.page,
      initial: true,
      children: [
        AutoRoute(page: OnboardingRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
      ],
    ),
    AutoRoute(page: HomeRoute.page),
  ];
}
