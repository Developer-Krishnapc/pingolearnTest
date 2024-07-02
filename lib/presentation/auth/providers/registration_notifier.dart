import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_utils.dart';
import '../../../data/repository/auth.dart';
import '../../../domain/model/load_error_state.dart';
import '../../../domain/model/user.dart';
import '../../routes/app_router.dart';
import '../../shared/providers/router.dart';

final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, LoadErrorState<void>>((ref) {
  return RegistrationNotifier(ref);
});

class RegistrationNotifier extends StateNotifier<LoadErrorState<void>> {
  RegistrationNotifier(this._ref)
      : super(LoadErrorState(data: null, loading: false)) {}

  final Ref _ref;

  final nameCtrl = TextEditingController();

  final emailCtrl = TextEditingController();

  final passCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameCtrl.dispose();
    passCtrl.dispose();
    emailCtrl.dispose();

    super.dispose();
  }

  Future<void> createUser({required BuildContext context}) async {
    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');

      final res = await _ref.read(authRepoProvider).createUser(
          userData: User(
              email: emailCtrl.text.toLowerCase().trim(),
              name: nameCtrl.text.trim(),
              password: passCtrl.text.trim()));
      res.fold((error) {
        state = state.copyWith(loading: false, error: error.message);
      }, (result) {
        AppUtils.flushBar(context, 'Registration Successfull..',
            isSuccessPopup: true);
        state = state.copyWith(loading: false, error: '');
        _ref.read(routerProvider).replaceAll([const MainRoute()]);
      });
    }
  }
}
