import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state_model.freezed.dart';
part 'pagination_state_model.g.dart';

@freezed
class PaginationState<T> with _$PaginationState<T> {
  factory PaginationState({
    @Default(true) bool loading,
    @Default(false) bool loadMore,
    @Default('') String error,
    @Default(1) int pageNumber,
    @Default(10) int pageSize,
    required T data,
    @Default(FilterState()) FilterState filter,
  }) = _PaginationState;
}

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    @Default('') String startDateFilter,
    @Default('') String endDateFilter,
    @Default(false) bool isDeactivate,
    @Default(true) bool isAdmin,
    @Default(true) bool isStaff,
  }) = _FilterState;

  factory FilterState.fromJson(Map<String, dynamic> json) =>
      _$FilterStateFromJson(json);
}
