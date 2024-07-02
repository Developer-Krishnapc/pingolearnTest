import 'package:flutter/material.dart';

import 'config/app_color.dart';

class AppStyle {
  AppStyle._();

  static List<BoxShadow> get shadow => [
        BoxShadow(
          color: AppColor.grey.withOpacity(0.12),
          blurRadius: 15,
          spreadRadius: 5,
          offset: const Offset(1, 1),
        ),
      ];
}
