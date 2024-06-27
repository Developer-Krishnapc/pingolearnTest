import 'package:dio/dio.dart';

// ignore: avoid_classes_with_only_static_members
class CustomRequestOptions {
  static RequestOptions fileExportOption({
    required RequestOptions data,
  }) {
    data.responseType = ResponseType.bytes;

    return data;
  }
}
