import 'package:freezed_annotation/freezed_annotation.dart';

part 'load_error_state.freezed.dart';

@freezed
class LoadErrorState<T> with _$LoadErrorState<T> {
  factory LoadErrorState({
    @Default(true) bool loading,
    @Default('') String error,
    required T data,
  }) = _LoadErrorState;
}
