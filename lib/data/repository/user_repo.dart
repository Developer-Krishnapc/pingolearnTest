import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/model/role_model.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repo.dart';
import '../model/common_success_model.dart';
import '../source/remote/user_source.dart';

part 'user_repo.g.dart';

@riverpod
UserRepository userRepo(UserRepoRef ref) {
  return UserRepositoryImpl(ref.watch(userSourceProvider));
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._source);

  final UserSource _source;

  @override
  Future<Either<AppException, User>> getUserById({required int id}) {
    return _source.getUserById(id).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateUserById({
    required int id,
    required String name,
    required String email,
    required List<String> roleCodeList,
    required String phone,
    required String password,
    required bool boolIsActive,
  }) {
    final Map<String, dynamic> body = {
      'id': id,
      'roles': roleCodeList,
      'is_deactivate': boolIsActive ? 'N' : 'Y',
    };

    if (name != null && name.isNotEmpty) {
      body['full_name'] = name;
    }
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    if (email != null && email.isNotEmpty) {
      body['email'] = email;
      body['username'] = email;
    }

    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }

    return _source.updateUserById(userId: id, body: body).guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> createUser({
    required String name,
    required String email,
    required List<String> roleCodeList,
    required String phone,
    required String password,
    String? imagefilePath,
  }) {
    final Map<String, dynamic> body = {
      'roles': roleCodeList,
      'full_name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
    if (imagefilePath != null) {
      return _source
          .createUser(data: jsonEncode(body), fileData: File(imagefilePath))
          .guardFuture();
    }
    return _source
        .createUser(
          data: jsonEncode(body),
        )
        .guardFuture();
  }

  @override
  Future<Either<AppException, List<User>>> userList({
    String? searchBy,
    required int pageNumber,
    required int pageSize,
    bool? isStaff,
    bool? isAdmin,
    bool? isDeactivated,
  }) {
    final Map<String, dynamic> body = {
      'page_number': pageNumber,
      'page_size': pageSize,
      'is_deactivate': 'N',
    };

    if (searchBy != null) {
      body['search_by'] = searchBy;
    }
    if (isStaff != null) {
      body['is_staff'] = isStaff;
    }

    if (isAdmin != null) {
      body['is_admin'] = isAdmin;
    }
    if (isDeactivated != null) {
      body['is_deactivate'] = isDeactivated ? 'Y' : 'N';
    }

    return _source.userList(body: body).guardFuture();
  }

  @override
  Future<Either<AppException, List<RoleModel>>> getRoleList() {
    return _source.getRoleList().guardFuture();
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateUserProfileImage({
    required String filePath,
    required int id,
  }) {
    return _source
        .updateProfileImg(fileData: File(filePath), userId: id)
        .guardFuture();
  }

  @override
  @override
  Future<Either<AppException, User>> getUser({required String accessToken}) {
    final body = {
      'access_token': accessToken,
    };
    return _source.getUser(body).guardFuture();
  }
}
