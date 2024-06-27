import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_stats_model.freezed.dart';
part 'home_stats_model.g.dart';

@freezed
class HomeStatsModel with _$HomeStatsModel {
  const factory HomeStatsModel({
    @JsonKey(name: 'sample') @Default(0) int totalDesign,
    @JsonKey(name: 'hanger') @Default(0) int totalHanger,
    @JsonKey(name: 'enquiry') @Default(0) int totalEnquiry,
  }) = _HomeStatsModel;
  factory HomeStatsModel.fromJson(Map<String, dynamic> json) =>
      _$HomeStatsModelFromJson(json);
}
