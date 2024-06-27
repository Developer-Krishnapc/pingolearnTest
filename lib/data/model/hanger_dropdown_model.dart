import 'package:freezed_annotation/freezed_annotation.dart';

part 'hanger_dropdown_model.freezed.dart';
part 'hanger_dropdown_model.g.dart';

@freezed
class HangerDropdownModel with _$HangerDropdownModel {
  const factory HangerDropdownModel({
    @JsonKey(name: 'hanger_id') @Default(-1) int id,
    @Default('') String name,
  }) = _HangerDropdownModel;

  factory HangerDropdownModel.fromJson(Map<String, dynamic> json) =>
      _$HangerDropdownModelFromJson(json);
}
