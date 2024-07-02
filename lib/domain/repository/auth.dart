import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../model/user.dart';

abstract class AuthRepository {
  Future<Either<AppException, String>> createUser({required User userData});

  Future<Either<AppException, String>> loginUser({required User userData});
}
