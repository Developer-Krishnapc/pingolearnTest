import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../extension/log.dart';

part 'shared_timer_provider.g.dart';

@riverpod
class TimerProvider extends _$TimerProvider {
  Timer? timerObj;
  @override
  int build() {
    return 0;
  }

  void startTime({required int seconds}) {
    state = 1;
    timerObj = Timer.periodic(Duration(seconds: seconds), (timer) {
      state = timer.tick;
      state.logError();
      (timer.tick == seconds).logError();
      if (timer.tick == seconds) {
        timerObj?.cancel();
        state = 0;
      }
    });
  }

  void disposeTimer() {}
}
