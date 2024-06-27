import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/extension/log.dart';

class LogInterceptorsWrapper extends QueuedInterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    '------------------------'.logError();
    'Api Error : ${err.requestOptions.path}'.logError();
    'Api Error : ${err.message}\n${err.response?.data}'.logError();
    '------------------------'.logError();
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    '------------------------'.logInfo();
    'Requesting ${options.baseUrl}${options.path}'.logInfo();
    'Requesting ${options.data}'.logInfo();
    'Requesting ${options.headers}'.logInfo();

    if (options.queryParameters.isNotEmpty) {
      'Requesting ${options.queryParameters}'.logInfo();
    }
    '------------------------'.logInfo();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    '\n------------------------'.logSuccess();
    'Response ${response.statusCode}'.logSuccess();
    'Response Data ${jsonEncode(response.data)}'.logSuccess();
    '------------------------'.logSuccess();
    handler.next(response);
  }
}
