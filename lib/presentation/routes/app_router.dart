import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/login.dart';
import '../auth/registration_page.dart';
import '../home/home.dart';
import '../main_page/main_page.dart';

import '../splash/splash.dart';
import 'guard/auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  AppRouter(this._ref);

  final Ref _ref;
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegistrationRoute.page),
        AutoRoute(
          page: MainRoute.page,
          guards: [AuthGuard(_ref)],
          children: [
            AutoRoute(
              page: HomeRoute.page,
            ),
          ],
        ),
      ];
}
