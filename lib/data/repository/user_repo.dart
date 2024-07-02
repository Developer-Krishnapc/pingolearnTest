import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repo.dart';
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
  Future<Either<AppException, User>> getUserByEmail({required String email}) {
    return _source.getUserByEmail(email: email);
  }
}
