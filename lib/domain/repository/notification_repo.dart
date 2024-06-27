import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/exceptions/app_exception.dart';
import '../../data/model/common_success_model.dart';
import '../../data/model/notification_count_res.dart';
import '../model/notification_model.dart';

abstract class NotificationRepository {
  Future<String?> getFirebaseToken();
  Stream<RemoteMessage> get onForegroundPushNotification;
  Stream<RemoteMessage> get onBackgroundPushNotification;
  Stream<String> get onTokenExpired;

  Future<void> saveFirebaseToken({
    required int userId,
    required String token,
    required String deviceType,
  });
  Future<Either<AppException, List<Notifications>>> getNotification(
    int pageNumber,
    int pageSize,
    int userId,
  );

  Future<Either<AppException, NotificationCountRes>> getNotificationCount({
    required int pageNumber,
    required int pageSize,
    required int userId,
    required bool isRead,
  });

  Future<Either<AppException, CommonSuccessModel>> updateNotificationRead({
    required int userId,
  });
}
