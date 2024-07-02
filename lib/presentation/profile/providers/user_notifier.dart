import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extension/log.dart';
import '../../../data/repository/user_repo.dart';
import '../../../domain/model/user.dart';
import '../../auth/providers/firebase_instance_provider.dart';
import '../../shared/model/user_state.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState<User>>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<UserState<User>> {
  UserNotifier(this._ref)
      : super(UserState(data: const User(), loading: false));

  final Ref _ref;

  Future<String?> getUser() async {
    String? response;
    state = state.copyWith(loading: true, error: '');
    final _repo = _ref.read(userRepoProvider);
    final email = _ref.read(firebaseAuthInstanceProvider).currentUser?.email;
    if (email != null) {
      final result = await _repo.getUserByEmail(email: email);
      await result.fold((l) {
        response = l.message;
        state = state.copyWith(error: l.message, loading: false);
      }, (r) async {
        r.logSuccess();
        state = state.copyWith(loading: false, error: '', data: r);
      });
    } else {
      response = 'Something went Wrong';
    }

    return response;
  }
}
