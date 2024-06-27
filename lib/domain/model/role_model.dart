import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    @Default(-1) int id,
    @Default('') String name,
    @Default('') String description,
    @Default('') String code,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}
