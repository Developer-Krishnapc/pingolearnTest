import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/news_model.dart';
part 'news_list_res.freezed.dart';
part 'news_list_res.g.dart';

@freezed
class NewsListRes with _$NewsListRes {
  const factory NewsListRes({
    @Default(<NewsModel>[]) List<NewsModel> articles,
  }) = _NewsListRes;
  factory NewsListRes.fromJson(Map<String, dynamic> json) =>
      _$NewsListResFromJson(json);
}
