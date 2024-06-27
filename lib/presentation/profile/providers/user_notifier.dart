import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/token_provider.dart';
import '../../../data/repository/notification_repo_impl.dart';
import '../../../data/repository/user_repo.dart';
import '../../../domain/model/user.dart';
import '../../shared/model/user_state.dart';

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState<User>>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<UserState<User>> {
  UserNotifier(this._ref)
      : super(UserState(data: const User(), loading: false));

  final Ref _ref;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passCtrl = TextEditingController();
  final selectedImagePath = TextEditingController();

  void init() {}

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    selectedImagePath.dispose();

    super.dispose();
  }

  Future<String?> getUserById({required int userId}) async {
    String? response;
    state = state.copyWith(loading: true, error: '');
    final _repo = _ref.read(userRepoProvider);
    state = state.copyWith(error: '', loading: true);
    final result = await _repo.getUserById(id: userId);
    await result.fold((l) {
      response = l.message;
      state = state.copyWith(error: l.message, loading: false);
    }, (r) async {
      final token =
          await _ref.read(notificationRepoProvider).getFirebaseToken();
      if (token != null)
        await _ref.read(notificationRepoProvider).saveFirebaseToken(
              userId: r.id,
              token: token,
              deviceType: Platform.isIOS ? 'ios' : 'android',
            );
      nameCtrl.text = r.fullName;
      phoneCtrl.text = r.phone;
      emailCtrl.text = r.email;
      state = state.copyWith(loading: false, error: '', data: r);
    });
    return response;
  }

  void updateSelectedImage({required String imagefilePath}) {
    selectedImagePath.text = imagefilePath;
    state = state.copyWith(data: state.data);
  }

  Future<String?> getUser() async {
    String? response;
    state = state.copyWith(loading: true, error: '');
    final accessToken =
        _ref.read(tokenNotifierProvider.select((value) => value.accessToken));
    final data =
        await _ref.read(userRepoProvider).getUser(accessToken: accessToken);
    await data.fold((l) {
      response = l.message;
      state = state.copyWith(loading: false, error: l.message);
    }, (r) async {
      final token =
          await _ref.read(notificationRepoProvider).getFirebaseToken();
      if (token != null) {
        _ref.read(notificationRepoProvider).saveFirebaseToken(
              userId: r.id,
              token: token,
              deviceType: Platform.isIOS ? 'ios' : 'android',
            );
      }

      state = state.copyWith(loading: false, error: '', data: r);
    });
    return response;
  }

  Future<bool> updateUserData() async {
    bool isUpdated = false;
    state = state.copyWith(loading: true, error: '');
    if (selectedImagePath.text.trim().isNotEmpty) {
      final res = await updateUserProfileImage();
      if (res != null) {
        state = state.copyWith(loading: false, error: res);
        return false;
      }
    }

    final res = await _ref.read(userRepoProvider).updateUserById(
          id: state.data.id,
          roleCodeList: [state.data.role],
          name: nameCtrl.text,
          email: emailCtrl.text,
          phone: phoneCtrl.text,
          password: passCtrl.text,
          boolIsActive: state.data.isDeactivate != 'Y',
        );
    res.fold((l) {
      state = state.copyWith(loading: false, error: l.message);
    }, (r) {
      isUpdated = true;
      state = state.copyWith(loading: false, error: '');
    });

    if (isUpdated) {
      getUserById(userId: state.data.id);
    }

    return isUpdated;
  }

  Future<String?> updateUserProfileImage() async {
    String? res;
    final data = await _ref.read(userRepoProvider).updateUserProfileImage(
          filePath: selectedImagePath.text,
          id: state.data.id,
        );
    data.fold((l) => res = l.message, (r) {});
    return res;
  }

  void clearData() {
    nameCtrl.clear();
    phoneCtrl.clear();
    emailCtrl.clear();
    passCtrl.clear();
  }
}
