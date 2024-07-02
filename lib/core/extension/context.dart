import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  Size get size => MediaQuery.of(this).size;
  EdgeInsets get padding => MediaQuery.of(this).padding;

  double get width {
    return size.width;
  }

  double widthByPercent(double percent) {
    return width * (percent / 100);
  }

  double get height {
    return size.height - padding.top - padding.bottom;
  }

  double heightByPercent(double percent) {
    return height * (percent / 100);
  }
}
