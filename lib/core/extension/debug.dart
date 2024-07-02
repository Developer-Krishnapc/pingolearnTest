import 'package:flutter/foundation.dart';

extension DebugStringExt on String {
  String get ifDebug => kDebugMode ? this : '';
}
