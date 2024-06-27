import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_stats_model.freezed.dart';
part 'common_stats_model.g.dart';

@freezed
class CommonStatsModel with _$CommonStatsModel {
  const factory CommonStatsModel({
    @Default('') String name,
    @Default(-1) int count,
  }) = _CommonStatsModel;

  factory CommonStatsModel.fromJson(Map<String, dynamic> json) =>
      _$CommonStatsModelFromJson(json);
}
