import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_output_model.freezed.dart';
part 'qr_output_model.g.dart';

@freezed
class QROutputModel with _$QROutputModel {
  const factory QROutputModel({
    @Default(-1) int id,
    @Default('') String moduleType,
  }) = _QROutputModel;

  factory QROutputModel.fromJson(Map<String, dynamic> json) =>
      _$QROutputModelFromJson(json);
}
