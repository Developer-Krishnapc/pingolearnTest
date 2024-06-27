// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/collection_dropdown_model.dart';
import 'collection_model.dart';
import 'design_model.dart';
import 'document_model.dart';

part 'hanger_model.freezed.dart';
part 'hanger_model.g.dart';

@freezed
class HangerListModel with _$HangerListModel {
  const factory HangerListModel({
    @Default(<HangerItem>[]) List<HangerItem> hangerItemList,
    @Default(<CollectionDropdownModel>[])
    List<CollectionDropdownModel> collectionList,
    CollectionDropdownModel? selectedCollection,
    @Default(false) bool isFilterApplied,
  }) = _HangerListModel;
  factory HangerListModel.fromJson(Map<String, dynamic> json) =>
      _$HangerListModelFromJson(json);
}

@freezed
class HangerModel with _$HangerModel {
  const factory HangerModel({
    @Default(<DocumentModel>[]) List<DocumentModel> selectedImageList,
    @Default(<CollectionDropdownModel>[])
    List<CollectionDropdownModel> collectionList,
    CollectionDropdownModel? selectedCollection,
    @Default(HangerItem()) HangerItem selectedHanger,
    @Default(0) int selectedImageListLength,
  }) = _HangerModel;
  factory HangerModel.fromJson(Map<String, dynamic> json) =>
      _$HangerModelFromJson(json);
}

@freezed
class HangerItem with _$HangerItem {
  const factory HangerItem({
    @JsonKey(name: 'hanger_id') @Default(-1) int id,
    @Default('') String name,
    @Default('') String code,
    @Default(<DocumentModel>[]) List<DocumentModel> images,
    @JsonKey(name: 'mill_reference_number') @Default('') String millRefNo,
    CollectionItem? collection,
    @JsonKey(name: 'is_deactivate') @Default('N') String isDeactivated,
    @JsonKey(name: 'sample_hanger')
    @Default(<DesignItem>[])
    List<DesignItem> sampleList,
    @JsonKey(name: 'buyer_reference_construction')
    @Default('')
    String buyerRefNo,
    @Default('') String composition,
    @JsonKey(name: 'construction') @Default('') String construction,
    @Default(0) int gsm,
    @Default(0) int width,
    @Default('') String count,
  }) = _HangerItem;
  factory HangerItem.fromJson(Map<String, dynamic> json) =>
      _$HangerItemFromJson(json);
}
