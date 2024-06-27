import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_count_res.freezed.dart';
part 'notification_count_res.g.dart';

@freezed
class NotificationCountRes with _$NotificationCountRes {
  const factory NotificationCountRes({
    @Default(-1) int count,
  }) = _NotificationCountRes;

  factory NotificationCountRes.fromJson(Map<String, dynamic> json) =>
      _$NotificationCountResFromJson(json);
}
