import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth.dart';
import '../../../domain/model/user.dart';
import '../../routes/app_router.dart';
import '../../shared/model/user_state.dart';
import '../../shared/providers/router.dart';

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, UserState<bool>>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<UserState<bool>> {
  LoginNotifier(this._ref) : super(UserState(data: false, loading: false));

  final Ref _ref;

  final emailCtrl =
      TextEditingController(text: kDebugMode ? 'krishna.test@yopmail.com' : '');
  final passwordCtrl =
      TextEditingController(text: kDebugMode ? 'KrishnaTest123' : '');
  final loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();

    super.dispose();
  }

  Future<void> login() async {
    if (loginFormKey.currentState?.validate() == true) {
      state = state.copyWith(error: '', loading: true);
      final res = await _ref.read(authRepoProvider).loginUser(
          userData: User(
              email: emailCtrl.text.toLowerCase().trim(),
              password: passwordCtrl.text.trim()));

      res.fold((error) {
        String? updateErrorMessage;
        switch (error.message) {
          case ('invalid-credential'):
            updateErrorMessage = 'Invalid email or password';
            break;
          case ('user-disabled'):
            updateErrorMessage =
                'Your email is disabled to use the application';
            break;
          case ('wrong-password'):
            updateErrorMessage = 'Invalid email or password';
        }
        state = state.copyWith(
            error: updateErrorMessage ?? error.message, loading: false);
      }, (user) {
        state = state.copyWith(loading: false, error: '');
        _ref.read(routerProvider).replaceAll([const MainRoute()]);
      });
    }
  }
}
