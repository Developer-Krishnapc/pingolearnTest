import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_success_model.freezed.dart';
part 'common_success_model.g.dart';

@freezed
class CommonSuccessModel with _$CommonSuccessModel {
  const factory CommonSuccessModel({
    @Default('') String message,
  }) = _CommonSuccessModel;

  factory CommonSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$CommonSuccessModelFromJson(json);
}
