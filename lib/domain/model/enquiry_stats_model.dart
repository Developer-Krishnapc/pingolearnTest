import 'package:freezed_annotation/freezed_annotation.dart';

part 'enquiry_stats_model.freezed.dart';
part 'enquiry_stats_model.g.dart';

@freezed
class EnquiryStatsModel with _$EnquiryStatsModel {
  const factory EnquiryStatsModel({
    @JsonKey(name: 'In Progress') @Default(0) int inProgress,
    @JsonKey(name: 'Completed') @Default(0) int completed,
    @JsonKey(name: 'New Enquiry') @Default(0) int newEnquiry,
    @JsonKey(name: 'Pending') @Default(0) int pending,
  }) = _EnquiryStatsModel;
  factory EnquiryStatsModel.fromJson(Map<String, dynamic> json) =>
      _$EnquiryStatsModelFromJson(json);
}
