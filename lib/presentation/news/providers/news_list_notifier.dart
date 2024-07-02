import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/news_repo_impl.dart';
import '../../../domain/model/news_list_model.dart';
import '../../../domain/model/pagination_state_model.dart';

final newsListNotifierProvider =
    StateNotifierProvider<NewsListNotifier, PaginationState<NewsListModel>>(
        (ref) {
  return NewsListNotifier(ref);
});

class NewsListNotifier extends StateNotifier<PaginationState<NewsListModel>> {
  NewsListNotifier(this._ref)
      : super(PaginationState(data: const NewsListModel()));

  final Ref _ref;

  Future<void> getNewsList() async {
    final data = await _ref.read(designRepoProvider).getTopHeadlines(
        pageNumber: state.pageNumber, pageSize: state.pageSize);

    data.fold((l) {
      state = state.copyWith(loadMore: false, loading: false, error: l.message);
    }, (r) {
      state = state.copyWith(
        loadMore: r.articles.length == state.pageSize,
        error: '',
        loading: false,
        pageNumber: state.pageNumber + 1,
        data: state.data.copyWith(
          newList: [...state.data.newList, ...r.articles],
        ),
      );
    });
  }

  Future<void> loadMore() async {
    if (state.loadMore) {
      await getNewsList();
    }
  }

  void reset({bool? isFilterApplied}) {
    state = state.copyWith(
      data: state.data.copyWith(
        newList: [],
      ),
      error: '',
      loadMore: false,
      loading: true,
      pageNumber: 1,
    );
  }
}
