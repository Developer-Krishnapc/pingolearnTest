import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'token.freezed.dart';
part 'token.g.dart';

@freezed
class Token with _$Token {
  const factory Token({
    @JsonKey(name: 'refresh_token') @Default('') String refreshToken,
    @JsonKey(name: 'access_token') @Default('') String accessToken,
    @Default(User()) User user,
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
