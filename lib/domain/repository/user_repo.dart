import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/common_success_model.dart';
import '../model/role_model.dart';
import '../model/user.dart';

abstract class UserRepository {
  Future<Either<AppException, User>> getUserById({required int id});
  Future<Either<AppException, CommonSuccessModel>> updateUserById({
    required int id,
    required String name,
    required String email,
    required List<String> roleCodeList,
    required String phone,
    required String password,
    required bool boolIsActive,
  });

  Future<Either<AppException, CommonSuccessModel>> createUser({
    required String name,
    required String email,
    required List<String> roleCodeList,
    required String phone,
    required String password,
    String? imagefilePath,
  });

  Future<Either<AppException, List<User>>> userList({
    String? searchBy,
    required int pageNumber,
    required int pageSize,
    bool? isStaff,
    bool? isAdmin,
    bool? isDeactivated,
  });
  Future<Either<AppException, List<RoleModel>>> getRoleList();
  Future<Either<AppException, User>> getUser({required String accessToken});
  Future<Either<AppException, CommonSuccessModel>> updateUserProfileImage({
    required String filePath,
    required int id,
  });
}
