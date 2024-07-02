import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/repository/news_repo.dart';
import '../../presentation/shared/providers/app_content.dart';
import '../model/news_list_res.dart';
import '../source/remote/news_source.dart';

part 'news_repo_impl.g.dart';

@riverpod
NewsRepository designRepo(DesignRepoRef ref) =>
    NewsRepositoryImpl(ref.read(designSourceProvider), ref);

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._source, this.ref);

  final DesignSource _source;
  final Ref ref;

  @override
  Future<Either<AppException, NewsListRes>> getTopHeadlines({
    required int pageNumber,
    required int pageSize,
  }) {
    final countryCode = ref.read(appContentProvider).countryCode.isEmpty
        ? 'in'
        : ref.read(appContentProvider).countryCode;
    return _source
        .getTopHeadlines(page: pageNumber, country: countryCode, size: pageSize)
        .guardFuture();
  }
}
