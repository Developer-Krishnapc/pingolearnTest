import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/collection_dropdown_model.dart';
import '../../data/model/hanger_dropdown_model.dart';
import 'document_model.dart';
import 'hanger_model.dart';
import 'home_stats_model.dart';

part 'design_model.freezed.dart';
part 'design_model.g.dart';

@freezed
class DesignListModel with _$DesignListModel {
  const factory DesignListModel({
    @Default(<DesignItem>[]) List<DesignItem> designItemList,
    @Default(<HangerDropdownModel>[]) List<HangerDropdownModel> hangerList,
    HangerDropdownModel? selectedHanger,
    @Default(false) bool isFilterApplied,
    @Default(HomeStatsModel()) HomeStatsModel stats,
    CollectionDropdownModel? selectedCollection,
    @Default(<CollectionDropdownModel>[])
    List<CollectionDropdownModel> collectionList,
    @Default(false) bool dropdownSearchLoading,
  }) = _DesignListModel;
  factory DesignListModel.fromJson(Map<String, dynamic> json) =>
      _$DesignListModelFromJson(json);
}

@freezed
class DesignModel with _$DesignModel {
  const factory DesignModel({
    @Default(<DocumentModel>[]) List<DocumentModel> selectedImageList,
    @Default(<HangerDropdownModel>[]) List<HangerDropdownModel> hangerList,
    @Default(<CollectionDropdownModel>[])
    List<CollectionDropdownModel> collectionList,
    @Default(DesignItem()) DesignItem selectedDesign,
    @Default(0) int selectedImageListLength,
    @Default(false) bool dropdownSearchLoading,
    HangerDropdownModel? selectedHanger,
    CollectionDropdownModel? selectedCollection,
  }) = _DesignModel;
  factory DesignModel.fromJson(Map<String, dynamic> json) =>
      _$DesignModelFromJson(json);
}

@freezed
class DesignItem with _$DesignItem {
  const factory DesignItem({
    @JsonKey(name: 'sample_id') @Default(-1) int id,
    @JsonKey(name: 'hanger_id') @Default(-1) int hangerId,
    @JsonKey(name: 'collection_id') @Default(-1) int collectionId,
    @JsonKey(name: 'collection_name') @Default('') String collectionName,
    @Default('') String name,
    @JsonKey(name: 'is_deactivate') @Default('N') String isDeactivated,
    @Default(<DocumentModel>[]) List<DocumentModel> images,
    HangerItem? hanger,
    @JsonKey(name: 'mill_reference_number') @Default('') String millRefNo,
    @JsonKey(name: 'buyer_reference_construction')
    @Default('')
    String buyerRefNo,
    @Default('') String composition,
    @JsonKey(name: 'construction') @Default('') String construction,
    @Default(0) int gsm,
    @Default(0) int width,
    @Default('') String count,
    @Default(DocumentModel()) DocumentModel qrCode,
  }) = _DesignItem;
  factory DesignItem.fromJson(Map<String, dynamic> json) =>
      _$DesignItemFromJson(json);
}
