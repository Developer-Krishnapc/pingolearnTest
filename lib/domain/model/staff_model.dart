import 'package:freezed_annotation/freezed_annotation.dart';

import 'predefined.dart';
import 'role_model.dart';
import 'user.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@freezed
class StaffListModel with _$StaffListModel {
  const factory StaffListModel({
    @Default(<User>[]) List<User> userList,
    @Default(false) bool onlyAdmin,
    @Default(false) bool onlyStaff,
    @Default(false) bool isDeactivated,
    @Default(false) bool isFilterApplied,
  }) = _StaffListModel;
  factory StaffListModel.fromJson(Map<String, dynamic> json) =>
      _$StaffListModelFromJson(json);
}

@freezed
class StaffModel with _$StaffModel {
  const factory StaffModel({
    @Default(User()) User user,
    String? selectedImagePath,
    bool? isDeactivated,
    @Default(<RoleModel>[]) List<RoleModel> roleList,
    RoleModel? selectedRole,
  }) = _StaffModel;
  factory StaffModel.fromJson(Map<String, dynamic> json) =>
      _$StaffModelFromJson(json);
}
