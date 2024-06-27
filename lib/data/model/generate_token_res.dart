import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/token.dart';

part 'generate_token_res.freezed.dart';
part 'generate_token_res.g.dart';

@freezed
class GenerateTokenRes with _$GenerateTokenRes {
  const factory GenerateTokenRes({
    @Default(Token()) Token tokens,
  }) = _GenerateTokenRes;

  factory GenerateTokenRes.fromJson(Map<String, dynamic> json) =>
      _$GenerateTokenResFromJson(json);
}
