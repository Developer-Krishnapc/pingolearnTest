import 'package:freezed_annotation/freezed_annotation.dart';

import 'news_model.dart';
part 'news_list_model.freezed.dart';

part 'news_list_model.g.dart';

@freezed
class NewsListModel with _$NewsListModel {
  const factory NewsListModel({
    @Default(<NewsModel>[]) List<NewsModel> newList,
  }) = _NewsListModel;
  factory NewsListModel.fromJson(Map<String, dynamic> json) =>
      _$NewsListModelFromJson(json);
}
