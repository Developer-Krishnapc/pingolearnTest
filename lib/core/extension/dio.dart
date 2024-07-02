import 'package:dio/dio.dart';

extension DioExtension on DioError {
  void toException() {
    // final res = switch (type) {
    //   DioErrorType.connectionTimeout ||
    //   DioErrorType.sendTimeout ||
    //   DioErrorType.receiveTimeout =>
    //     TimeoutException(),
    //   DioErrorType.connectionError => ConnectionException(),
    //   DioErrorType.cancel => CancelRequestException(),
    //   DioErrorType.unknown => UnknownException(),
    //   DioErrorType.badCertificate => BadCertificateException(),
    //   DioErrorType.badResponse => BadResponseException(),
    // };
  }
}
