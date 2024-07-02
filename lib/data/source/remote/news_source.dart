import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../helper/dio_instance.dart';
import '../../model/news_list_res.dart';

part 'news_source.g.dart';

@riverpod
DesignSource designSource(DesignSourceRef ref) {
  return DesignSource(ref.watch(dioInstanceProvider));
}

@RestApi()
abstract class DesignSource {
  factory DesignSource(Dio _dio) => _DesignSource(_dio);

  @GET(Constants.topHeadlines)
  Future<NewsListRes> getTopHeadlines({
    @Query('pageSize') required int size,
    @Query('page') required int page,
    @Query('country') required String country,
  });
}
