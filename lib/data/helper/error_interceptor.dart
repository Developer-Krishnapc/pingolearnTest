import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/constants/constants.dart';
import '../../core/constants/request_options.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/utils/app_utils.dart';

class ErrorInterceptorsWrapper extends QueuedInterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = AppException(
      type: ErrorType.network,
      message: (err.error is SocketException)
          ? 'Network is unreachable'
          : 'Something went wrong!',
    );
    AppUtils.checkError(err.response?.data, err.requestOptions).fold(
      (error) => handler.reject(error),
      (response) => handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: error,
        ),
      ),
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == Constants.exportHanger ||
        options.path == Constants.exportHangerPDF ||
        options.path == Constants.exportEnquiry ||
        options.path == Constants.exportDesign) {
      handler.next(
        CustomRequestOptions.fileExportOption(
          data: options,
        ),
      );
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppUtils.checkError(response.data, response.requestOptions).fold(
      (error) => handler.reject(error),
      (result) {
        response.data = AppUtils.convertDataToMap(result);
        handler.next(response);
      },
    );
  }
}
