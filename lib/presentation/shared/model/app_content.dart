import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_content.freezed.dart';
part 'app_content.g.dart';

@freezed
class AppContentModel with _$AppContentModel {
  const factory AppContentModel({
    @Default('') String countryCode,
  }) = _AppContentModel;

  factory AppContentModel.fromJson(Map<String, dynamic> json) =>
      _$AppContentModelFromJson(json);
}
