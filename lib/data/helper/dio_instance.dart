import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/constants.dart';
import '../../core/providers/token_provider.dart';
import '../../domain/model/token.dart';
import 'error_interceptor.dart';
import 'log_interceptor.dart';
import 'token_interceptor.dart';

part 'dio_instance.g.dart';

@riverpod
Dio dioInstance(DioInstanceRef ref) {
  final token = ref.watch(tokenNotifierProvider);
  return DioInstance(ref, token: token);
}

class DioInstance with DioMixin implements Dio {
  DioInstance(this._ref, {this.baseUrl, this.token}) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? Constants.instance.baseUrl,
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
    this.options = options;
    httpClientAdapter = IOHttpClientAdapter();
    _setUpInterceptor();
  }

  final Ref _ref;
  final String? baseUrl;
  final Token? token;

  Future<void> _setUpInterceptor() async {
    options.headers['Authorization'] = 'Bearer ${token?.accessToken}';

    interceptors.add(LogInterceptorsWrapper());
    interceptors.add(TokenInterceptorsWrapper(_ref));
    interceptors.add(ErrorInterceptorsWrapper());
  }
}
