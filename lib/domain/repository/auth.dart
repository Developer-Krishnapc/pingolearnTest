import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/generate_token_res.dart';
import '../model/token.dart';

abstract class AuthRepository {
  Future<Either<AppException, GenerateTokenRes>> generateToken({
    required String username,
    required String password,
  });
  Future<Either<AppException, Token>> refreshToken(String token);
  Future<Either<AppException, bool>> checkServerConnection();
}
