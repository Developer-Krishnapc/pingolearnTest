import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class Notifications with _$Notifications {
  const factory Notifications({
    @JsonKey(name: 'message') @Default('') String description,
    @JsonKey(name: 'is_read') @Default('') String isRead,
    @JsonKey(name: 'created_at') @Default('') String date,
    @Default('') String title,
  }) = _Notifications;

  factory Notifications.fromJson(Map<String, dynamic> json) =>
      _$NotificationsFromJson(json);
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @Default(<Notifications>[]) List<Notifications> notificationList,
    @Default(false) bool isReadPending,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
