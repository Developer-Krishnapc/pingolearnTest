import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/token_provider.dart';
import '../../../data/source/local/shar_pref.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._ref);

  final Ref _ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    final token = await _ref.read(sharedPrefProvider).getToken();

    if (token != null) {
      await _ref.read(tokenNotifierProvider.notifier).updateToken(token);
      // if user is authenticated we continue
      resolver.next();
    } else {
      // we redirect the user to our login page
      // router.push(
      //   const LoginRoute(),
      // );
      resolver.next();
    }
  }
}
