import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_model.freezed.dart';
part 'access_model.g.dart';

@freezed
class AccessModel with _$AccessModel {
  const factory AccessModel({
    @JsonKey(name: 'COLLECTION') AccessModelItem? collection,
    @JsonKey(name: 'ENQUIRY') AccessModelItem? enquiry,
    @JsonKey(name: 'HANGER') AccessModelItem? hanger,
    @JsonKey(name: 'SAMPLE') AccessModelItem? design,
    @JsonKey(name: 'USER') AccessModelItem? user,
  }) = _AccessModel;
  factory AccessModel.fromJson(Map<String, dynamic> json) =>
      _$AccessModelFromJson(json);
}

@freezed
class AccessModelItem with _$AccessModelItem {
  const factory AccessModelItem({
    @JsonKey(name: 'create_access') @Default(false) bool create,
    @JsonKey(name: 'read_access') @Default(false) bool read,
    @JsonKey(name: 'update_access') @Default(false) bool update,
    @JsonKey(name: 'delete_access') @Default(false) bool delete,
  }) = _AccessModelItem;
  factory AccessModelItem.fromJson(Map<String, dynamic> json) =>
      _$AccessModelItemFromJson(json);
}
