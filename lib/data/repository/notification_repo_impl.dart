import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/extension/future.dart';
import '../../domain/model/notification_model.dart';
import '../../domain/repository/notification_repo.dart';
import '../model/common_success_model.dart';
import '../model/notification_count_res.dart';
import '../source/remote/notification_source.dart';

part 'notification_repo_impl.g.dart';

@riverpod
NotificationRepoImpl notificationRepo(NotificationRepoRef ref) {
  return NotificationRepoImpl(ref.watch(notificationSourceProvider));
}

class NotificationRepoImpl implements NotificationRepository {
  NotificationRepoImpl(this._source);

  final NotificationSource _source;

  @override
  Future<Either<AppException, List<Notifications>>> getNotification(
    int pageNumber,
    int pageSize,
    int userId,
  ) async {
    final body = {
      'per_page': pageSize,
      'page': pageNumber,
      'user_id': userId,
    };
    return _source.getNotification(body).guardFuture();
  }

  @override
  Future<String?> getFirebaseToken() {
    return FirebaseMessaging.instance.getToken();
  }

  @override
  Stream<RemoteMessage> get onBackgroundPushNotification =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Stream<RemoteMessage> get onForegroundPushNotification =>
      FirebaseMessaging.onMessage;

  @override
  Stream<String> get onTokenExpired =>
      FirebaseMessaging.instance.onTokenRefresh;

  @override
  Future<void> saveFirebaseToken({
    required int userId,
    required String token,
    required String deviceType,
  }) {
    final body = {
      'user_id': userId,
      'device_type': deviceType,
      'firebase_token': token,
      'device_id': '1234',
    };

    return _source.updateFirebaseToken(body: body);
  }

  @override
  Future<Either<AppException, CommonSuccessModel>> updateNotificationRead({
    required int userId,
  }) {
    return _source.updateNotificationRead(userId: userId).guardFuture();
  }

  @override
  Future<Either<AppException, NotificationCountRes>> getNotificationCount({
    required int pageNumber,
    required int pageSize,
    required int userId,
    required bool isRead,
  }) {
    final body = {
      'per_page': pageSize,
      'page': pageNumber,
      'user_id': userId,
      'is_read': isRead ? 'Y' : 'N',
    };
    return _source.countNotification(body).guardFuture();
  }

  // @override
  // Future<Either<AppException, NotificationCountRes>> getNotificationUnreadCount(
  //   int userId,
  // ) {
  //   final body = {
  //     'type': 'NOTIFICATION',
  //     'isReadNotification': false,
  //     'toUserId': '[$userId]',
  //   };
  //   return _source.getNotificationUnreadCount(body: body).guardFuture();
  // }

  // @override
  // Future<Either<AppException, VerifyOtpRes>> markAsRead() {
  //   return _source.updateNotificationRead().guardFuture();
  // }
}
