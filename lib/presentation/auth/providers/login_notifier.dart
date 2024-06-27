import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../core/providers/token_provider.dart';
import '../../../data/repository/auth.dart';
import '../../profile/providers/user_notifier.dart';
import '../../routes/app_router.dart';
import '../../shared/model/user_state.dart';
import '../../shared/providers/app_content.dart';
import '../../shared/providers/router.dart';

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, UserState<bool>>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<UserState<bool>> {
  LoginNotifier(this._ref) : super(UserState(data: false, loading: false));

  final Ref _ref;

  final emaiCtrl =
      TextEditingController(text: kDebugMode ? 'admin@gmail.com' : '');
  final passwordCtrl =
      TextEditingController(text: kDebugMode ? 'Admin123' : '');
  final loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emaiCtrl.dispose();
    passwordCtrl.dispose();

    super.dispose();
  }

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() == true) {
      final _repo = _ref.read(authRepoProvider);
      state = state.copyWith(error: '', loading: true);
      final result = await _repo.generateToken(
        username: emaiCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      await result.fold(error, (result) async {
        final tokenNotifier = _ref.read(tokenNotifierProvider.notifier);
        tokenNotifier.updateToken(result.tokens);
        await Future.delayed(const Duration(milliseconds: 100));

        _ref.read(userNotifierProvider);
        final userNotifier = _ref.read(userNotifierProvider.notifier);

        final data =
            await userNotifier.getUserById(userId: result.tokens.user.id);

        if (data != null && data == 'User Deactivated') {
          final appContent = _ref.read(appContentProvider);
          state = state.copyWith(
            loading: false,
            error:
                'Your account is been deactivated contact admin\nAdmin No: ${appContent.adminPhone}\nAdmin Email: ${appContent.adminEmail}',
          );
        } else {
          state = state.copyWith(loading: false, error: '');
          _ref.read(routerProvider).replaceAll([const MainRoute()]);
        }
      });
    }
  }

  Future<void> error(AppException error) async {
    state = state.copyWith(error: error.message, loading: false);
  }
}
