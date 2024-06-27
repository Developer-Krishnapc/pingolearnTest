// ignore_for_file: file_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saveFirebaseTokenRes.freezed.dart';
part 'saveFirebaseTokenRes.g.dart';

@freezed
class SaveFirebaseTokenRes with _$SaveFirebaseTokenRes {
  const factory SaveFirebaseTokenRes({
    @Default('') String firebaseToken,
  }) = _SaveFirebaseTokenRes;

  factory SaveFirebaseTokenRes.fromJson(Map<String, dynamic> json) =>
      _$SaveFirebaseTokenResFromJson(json);
}
