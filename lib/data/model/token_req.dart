import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_req.freezed.dart';
part 'token_req.g.dart';

@freezed
class TokenReq with _$TokenReq {
  const factory TokenReq({
    @Default('') String username,
    @Default('') String password,
  }) = _TokenReq;

  factory TokenReq.fromJson(Map<String, dynamic> json) =>
      _$TokenReqFromJson(json);
}
