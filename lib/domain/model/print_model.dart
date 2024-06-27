import 'package:freezed_annotation/freezed_annotation.dart';

import 'design_model.dart';
import 'hanger_model.dart';

part 'print_model.freezed.dart';
part 'print_model.g.dart';

@freezed
class PrintModel with _$PrintModel {
  const factory PrintModel({
    @Default(<HangerItem>[]) List<HangerItem> hangerList,
    @Default(<DesignItem>[]) List<DesignItem> designList,
    @Default(0) int totalItems,
    @Default('') String moduleType,
    @Default(0) int currentItemSent,
    @Default(false) bool itemLoader,
  }) = _PrintModel;

  factory PrintModel.fromJson(Map<String, dynamic> json) =>
      _$PrintModelFromJson(json);
}
