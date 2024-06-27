import 'package:freezed_annotation/freezed_annotation.dart';

part 'enquiry_item_body_model.freezed.dart';
part 'enquiry_item_body_model.g.dart';

@freezed
class EnquiryBodyModel with _$EnquiryBodyModel {
  const factory EnquiryBodyModel({
    @Default(-1) int id,
    @JsonKey(name: 'status_id') @Default(-1) int statusId,
  }) = _EnquiryBodyModel;

  factory EnquiryBodyModel.fromJson(Map<String, dynamic> json) =>
      _$EnquiryBodyModelFromJson(json);
}
