import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_timer_model.freezed.dart';
part 'error_timer_model.g.dart';

@freezed
class ErrorTimer with _$ErrorTimer {
  const factory ErrorTimer({
    @Default('') String errorText,
    @Default(0) int timer,
  }) = _ErrorTimer;

  factory ErrorTimer.fromJson(Map<String, dynamic> json) =>
      _$ErrorTimerFromJson(json);
}
