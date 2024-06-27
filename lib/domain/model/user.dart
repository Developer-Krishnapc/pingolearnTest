import 'package:freezed_annotation/freezed_annotation.dart';

import 'access_model.dart';
import 'document_model.dart';
import 'predefined.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @Default(-1) int id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String password,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @Default('') String phone,
    @Default('') String role,
    Predefined? status,
    Predefined? selectedStatus,
    @JsonKey(name: 'profile_img')
    @Default(DocumentModel())
    DocumentModel profileImage,
    @JsonKey(name: 'is_deactivate') @Default('N') String isDeactivate,
    @JsonKey(name: 'modules') @Default(AccessModel()) AccessModel access,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
