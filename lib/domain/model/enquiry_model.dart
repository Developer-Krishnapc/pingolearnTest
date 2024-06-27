import 'package:freezed_annotation/freezed_annotation.dart';

import 'design_model.dart';
import 'enquiry_stats_model.dart';
import 'hanger_model.dart';
import 'predefined.dart';

part 'enquiry_model.freezed.dart';
part 'enquiry_model.g.dart';

@freezed
class EnquiryListModel with _$EnquiryListModel {
  const factory EnquiryListModel({
    @Default(<EnquiryItem>[]) List<EnquiryItem> enquiryList,
    @Default(<Predefined>[]) List<Predefined> statusList,
    Predefined? selectedStatus,
    @Default(false) bool isFilterApplied,
    @Default(EnquiryStatsModel()) EnquiryStatsModel enquiryStats,
  }) = _EnquiryListModel;
  factory EnquiryListModel.fromJson(Map<String, dynamic> json) =>
      _$EnquiryListModelFromJson(json);
}

@freezed
class EnquiryModel with _$EnquiryModel {
  const factory EnquiryModel({
    @Default(<EnquiryItem>[]) List<EnquiryItem> enquiryItemList,
    @Default(EnquiryItem()) EnquiryItem enquiryItem,
    @Default(<Predefined>[]) List<Predefined> statusList,
    Predefined? enquiryItemSelectedStatus,
    Predefined? selectedStatus,
  }) = _EnquiryModel;
  factory EnquiryModel.fromJson(Map<String, dynamic> json) =>
      _$EnquiryModelFromJson(json);
}

@freezed
class EnquiryItem with _$EnquiryItem {
  const factory EnquiryItem({
    @JsonKey(name: 'enquiry_id') @Default(-1) int enquiryId,
    @JsonKey(name: 'enquiry_item_id') @Default(-1) int enquiryItemId,
    @JsonKey(name: 'created_at') @Default('') String enquiryDate,
    @JsonKey(name: 'images') @Default('') String image,
    @Default('') String uniqueId,
    @Default('') String name,
    @JsonKey(name: 'mobile_no') @Default('') String phone,
    @Default('') String email,
    @Default('') String location,
    @Default('') String description,
    Predefined? status,
    @JsonKey(name: 'status_id') @Default(-1) statusId,
    @JsonKey(name: 'status_name') @Default('') String statusName,
    HangerItem? hanger,
    @JsonKey(name: 'sample') DesignItem? design,
    @Default(true) bool isLocallyAdded,
  }) = _EnquiryItem;
  factory EnquiryItem.fromJson(Map<String, dynamic> json) =>
      _$EnquiryItemFromJson(json);
}
