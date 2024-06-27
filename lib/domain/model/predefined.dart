import 'package:freezed_annotation/freezed_annotation.dart';

part 'predefined.freezed.dart';
part 'predefined.g.dart';

@freezed
class Predefined with _$Predefined {
  const factory Predefined({
    @JsonKey(name: 'predefined_id') @Default(-1) int predefinedId,
    @Default('') String name,
    @JsonKey(name: 'entity_type') @Default('') String entityType,
    @Default('') String code,
  }) = _Predefined;

  factory Predefined.fromJson(Map<String, dynamic> json) =>
      _$PredefinedFromJson(json);
}
