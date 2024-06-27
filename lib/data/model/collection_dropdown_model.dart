import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_dropdown_model.freezed.dart';
part 'collection_dropdown_model.g.dart';

@freezed
class CollectionDropdownModel with _$CollectionDropdownModel {
  const factory CollectionDropdownModel({
    @JsonKey(name: 'collection_id') @Default(-1) int id,
    @Default('') String name,
  }) = _CollectionDropdownModel;

  factory CollectionDropdownModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionDropdownModelFromJson(json);
}
