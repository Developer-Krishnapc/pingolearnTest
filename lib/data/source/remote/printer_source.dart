import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helper/dio_instance.dart';
import '../../model/common_success_model.dart';

part 'printer_source.g.dart';

// @riverpod
// class PrinterSourceNotifier extends _$PrinterSourceNotifier {
//   @override
//   PrinterSource build() {
//     return PrinterSource(
//       DioInstance(ref, baseUrl: 'http://192.168.68.102:8080/'),
//     );
//   }
// }

@riverpod
PrinterSource printerSource(PrinterSourceRef ref, String baseUrl) {
  return PrinterSource(DioInstance(
    ref,
    baseUrl: baseUrl,
  ));
}

@RestApi()
abstract class PrinterSource {
  factory PrinterSource(
    Dio _dio,
  ) =>
      _PrinterSource(_dio);

  @POST('')
  Future<CommonSuccessModel> printLabel(
    @Body() Map<String, dynamic> body,
  );

  @GET('')
  Future<CommonSuccessModel> dummy();
}
