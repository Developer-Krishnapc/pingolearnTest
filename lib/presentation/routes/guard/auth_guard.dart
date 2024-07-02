import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/firebase_instance_provider.dart';
import '../../shared/providers/router.dart';
import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._ref);

  final Ref _ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (_ref.read(firebaseAuthInstanceProvider).currentUser == null) {
      resolver.redirect(LoginRoute());
    } else {
      resolver.next();
    }
  }
}
