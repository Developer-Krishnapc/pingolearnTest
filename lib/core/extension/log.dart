import 'dart:developer';

extension LogExtension on Object? {
  void logInfo([String? name]) {
    log('\x1b[35m$this\x1B[0m', name: name ?? 'Info');
  }

  void logSuccess() {
    log('\x1B[32m$this\x1B[0m', name: 'Success');
  }

  void logError([String? name]) {
    log('\x1B[31m$this\x1B[0m', name: name ?? 'Error');
  }

  void logWarning() {
    log('\x1B[33m$this\x1B[0m', name: 'Warning');
  }
}
