import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/model/notification_model.dart';
import '../../helper/dio_instance.dart';
import '../../model/common_success_model.dart';
import '../../model/notification_count_res.dart';
import '../../model/saveFirebaseTokenRes.dart';

part 'notification_source.g.dart';

@riverpod
NotificationSource notificationSource(NotificationSourceRef ref) {
  return NotificationSource(ref.watch(dioInstanceProvider));
}

@RestApi()
abstract class NotificationSource {
  factory NotificationSource(Dio _dio) => _NotificationSource(_dio);
  @POST(Constants.getNotificationList)
  Future<List<Notifications>> getNotification(
    @Body() Map<String, dynamic> body,
  );

  @POST(Constants.getNotificationCount)
  Future<NotificationCountRes> countNotification(
    @Body() Map<String, dynamic> body,
  );

  @POST(Constants.updateFirebaseToken)
  Future<SaveFirebaseTokenRes> updateFirebaseToken({
    @Body() required Map<String, dynamic> body,
  });

  @GET(Constants.updateNotificationRead)
  Future<CommonSuccessModel> updateNotificationRead({
    @Path() required int userId,
  });

  // @GET(Constants.markAsRead)
  // Future<VerifyOtpRes> updateNotificationRead();
}
