import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_enquiry_item_res.freezed.dart';
part 'create_enquiry_item_res.g.dart';

@freezed
class AddEnquiryItemRes with _$AddEnquiryItemRes {
  const factory AddEnquiryItemRes({
    @Default('') String message,
    @JsonKey(name: 'enquiry_item_id') @Default(<int>[]) List<int> enquiryItemId,
  }) = _AddEnquiryItemRes;

  factory AddEnquiryItemRes.fromJson(Map<String, dynamic> json) =>
      _$AddEnquiryItemResFromJson(json);
}
