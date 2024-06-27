import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_content.freezed.dart';
part 'app_content.g.dart';

@freezed
class AppContentModel with _$AppContentModel {
  const factory AppContentModel({
    @Default(SocialMediaLinks()) SocialMediaLinks socialMedia,
    @Default(UpdatePageData()) UpdatePageData updatePageData,
    @Default('') String hangerLabelTemplate,
    @Default('') String designLabelTemplate,
    @Default('') String adminPhone,
    @Default('') String adminEmail,
  }) = _AppContentModel;

  factory AppContentModel.fromJson(Map<String, dynamic> json) =>
      _$AppContentModelFromJson(json);
}

@freezed
class UpdatePageData with _$UpdatePageData {
  const factory UpdatePageData({
    @Default('') String lottieUrl,
  }) = _UpdatePageData;

  factory UpdatePageData.fromJson(Map<String, dynamic> json) =>
      _$UpdatePageDataFromJson(json);
}

@freezed
class SocialMediaLinks with _$SocialMediaLinks {
  const factory SocialMediaLinks({
    @Default('') String instagram,
    @Default('') String facebook,
    @Default('') String linkedin,
    @Default('') String twitter,
    @Default('') String aboutUs,
    @Default('') String iOSAppId,
    @Default('') String androidId,
  }) = _SocialMediaLinks;

  factory SocialMediaLinks.fromJson(Map<String, dynamic> json) =>
      _$SocialMediaLinksFromJson(json);
}
