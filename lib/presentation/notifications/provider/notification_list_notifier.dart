import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/exceptions/app_exception.dart';
import '../../../data/repository/notification_repo_impl.dart';
import '../../../domain/model/notification_model.dart';
import '../../../domain/model/pagination_state_model.dart';
import '../../profile/providers/user_notifier.dart';

final notificationListNotifierProvider = StateNotifierProvider<
    NotificationListNotifier, PaginationState<NotificationModel>>((
  ref,
) {
  return NotificationListNotifier(
    ref,
  );
});

class NotificationListNotifier
    extends StateNotifier<PaginationState<NotificationModel>> {
  NotificationListNotifier(
    this._ref,
  ) : super(
          PaginationState(
            data: const NotificationModel(),
          ),
        );

  final Ref _ref;

  Future<void> getNotificationList() async {
    final userId =
        _ref.read(userNotifierProvider.select((value) => value.data.id));
    final result = await _ref.read(notificationRepoProvider).getNotification(
          state.pageNumber,
          state.pageSize,
          userId,
        );
    result.fold(onException, (result) {
      state = state.copyWith(
        data: state.data.copyWith(
          notificationList: [...state.data.notificationList, ...result],
        ),
        loadMore: result.length == state.pageSize,
        error: '',
        loading: false,
        pageNumber: state.pageNumber + 1,
      );
    });
  }

  void onException(AppException error) {
    state = state.copyWith(error: error.message, loading: false);
  }

  Future<void> loadMore() async {
    if (state.loadMore) {
      await getNotificationList();
    }
  }

  void reset() {
    state = PaginationState(
      data: state.data.copyWith(notificationList: []),
      filter: state.filter,
    );
  }

  Future<void> getUnreadPendingCount() async {
    final userId =
        _ref.read(userNotifierProvider.select((value) => value.data.id));
    final result =
        await _ref.read(notificationRepoProvider).getNotificationCount(
              pageNumber: 1,
              pageSize: 999999,
              userId: userId,
              isRead: false,
            );
    result.fold((l) => null, (r) {
      if (r.count > 0) {
        state = state.copyWith(data: state.data.copyWith(isReadPending: true));
      }
    });
  }

  void clearList() {
    state = PaginationState(
      data: state.data.copyWith(notificationList: []),
      filter: state.filter.copyWith(
        startDateFilter: '',
        endDateFilter: '',
      ),
    );
  }

  Future<void> updateNotificationRead() async {
    final userId =
        _ref.read(userNotifierProvider.select((value) => value.data.id));
    final response = await _ref
        .read(notificationRepoProvider)
        .updateNotificationRead(userId: userId);
    response.fold((l) {}, (r) {
      state = state.copyWith(data: state.data.copyWith(isReadPending: false));
      reset();
      getNotificationList();
    });
  }
}
