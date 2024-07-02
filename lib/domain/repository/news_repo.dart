import 'package:dartz/dartz.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/news_list_res.dart';

abstract class NewsRepository {
  Future<Either<AppException, NewsListRes>> getTopHeadlines({
    required int pageNumber,
    required int pageSize,
  });
}
