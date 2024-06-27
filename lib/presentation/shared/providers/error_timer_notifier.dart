import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extension/log.dart';
import '../../../data/model/error_timer_model.dart';

final errorTimerNotifierProvider =
    StateNotifierProvider.family<ErrorTimerNotifier, ErrorTimer, String>(
        (ref, errorTxt) {
  return ErrorTimerNotifier(ref);
});

class ErrorTimerNotifier extends StateNotifier<ErrorTimer> {
  ErrorTimerNotifier(
    this._ref,
  ) : super(const ErrorTimer()) {
    init();
    // reset();
    // getTransactionList();
  }

  final Ref _ref;
  int seconds = 3;

  Timer? timerObj;
  void init() {
    // startTime();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void resetTime() {
    state = const ErrorTimer();
  }

  Future<void> startTime({required int seconds, required String error}) async {
    if (state.timer != 0) {
      return;
    }
    state = state.copyWith(timer: 1, errorText: error);
    timerObj = Timer(Duration(seconds: seconds), () {
      state = state.copyWith(timer: 0, errorText: '');
      'ended'.logError();
    });
  }
}
