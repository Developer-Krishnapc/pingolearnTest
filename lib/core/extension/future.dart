import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../exceptions/app_exception.dart';

extension FutureExtension on Future {
  Future<Either<AppException, T>> guardFuture<T>() async {
    try {
      final T res = await (this as Future<T>);
      return right(res);
    } on Exception catch (e) {
      AppException? error =
          AppException(type: ErrorType.other, message: 'Something went wrong!');
      if (e is DioError && e.error is AppException) {
        error = e.error as AppException?;
      }
      return left(error ?? AppException(type: ErrorType.other, message: ''));
    }
  }
}

extension FutureEitherExtension<T> on Future<Either<AppException, T>> {
  Future<T> getResultOrNull({Function(AppException error)? onError}) async {
    late T result;
    (await this).fold((error) {
      onError?.call(error);
    }, (data) {
      result = data;
    });
    return result;
  }
}
