import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_model.dart';

part 'collection_model.freezed.dart';
part 'collection_model.g.dart';

@freezed
class CollectionModel with _$CollectionModel {
  const factory CollectionModel({
    @Default(<CollectionItem>[]) List<CollectionItem> collectionItemList,
    // @Default(<CollectionItem>[]) List<CollectionItem> hangerList,
    @Default(<DocumentModel>[]) List<DocumentModel> selectedImageList,
    @Default(0) int selectedImageListLength,
  }) = _CollectionModel;
  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionModelFromJson(json);
}

@freezed
class CollectionItem with _$CollectionItem {
  const factory CollectionItem({
    @JsonKey(name: 'collection_id') @Default(-1) int id,
    @Default('') String name,
    @Default(<DocumentModel>[]) List<DocumentModel> images,
    @JsonKey(name: 'is_deactivate') @Default('N') String isDeactivated,
  }) = _CollectionItem;
  factory CollectionItem.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemFromJson(json);
}
