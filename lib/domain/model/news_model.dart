import 'package:freezed_annotation/freezed_annotation.dart';
part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
class NewsModel with _$NewsModel {
  const factory NewsModel({
    @Default('') String title,
    @Default('') String description,
    @JsonKey(name: 'urlToImage') String? imageUrl,
    String? publishedAt,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
}
