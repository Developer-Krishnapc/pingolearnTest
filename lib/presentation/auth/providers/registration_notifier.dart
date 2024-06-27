import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extension/log.dart';
import '../../../core/utils/debounce.dart';
import '../../../domain/model/load_error_state.dart';
import '../../routes/app_router.dart';
import '../../shared/providers/router.dart';
import 'firebase_instance_provider.dart';

final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, LoadErrorState<void>>((ref) {
  return RegistrationNotifier(ref);
});

class RegistrationNotifier extends StateNotifier<LoadErrorState<void>> {
  RegistrationNotifier(this._ref)
      : super(LoadErrorState(data: null, loading: false)) {}

  final Ref _ref;

  final debounce = Debounce(millisecond: 1000);

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

  Future<void> createUser() async {
    if (formKey.currentState?.validate() == true) {
      state = state.copyWith(loading: true, error: '');
      try {
        await _ref
            .read(firebaseAuthInstanceProvider)
            .createUserWithEmailAndPassword(
                email: emailCtrl.text.toLowerCase().trim(),
                password: passCtrl.text.trim());

        state = state.copyWith(loading: false, error: '');
        _ref.read(routerProvider).push(HomeRoute());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          state = state.copyWith(
              error: 'The account already exists for this email.',
              loading: false);
        } else if (e.code == 'weak-password') {
          state = state.copyWith(
              error: 'The password provided is too weak.', loading: false);
        } else {
          e.code.logError();

          state = state.copyWith(error: 'Something went wrong', loading: false);
        }
      } catch (e) {
        e.logError();
        state = state.copyWith(loading: false, error: 'Something went wrong');
      }
    }
  }
}
