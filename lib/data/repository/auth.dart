import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/auth.dart';
import '../source/remote/auth.dart';

part 'auth.g.dart';

@riverpod
AuthRepository authRepo(AuthRepoRef ref) =>
    AuthRepositoryImpl(ref.read(authSourceProvider));

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._source);

  final AuthSource _source;

  @override
  Future<Either<AppException, String>> createUser({required User userData}) {
    return _source.registerUser(userData: userData);
  }

  @override
  Future<Either<AppException, String>> loginUser({required User userData}) {
    return _source.loginUser(userData: userData);
  }
}
