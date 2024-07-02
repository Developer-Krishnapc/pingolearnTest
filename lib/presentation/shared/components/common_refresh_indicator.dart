import 'package:flutter/material.dart';

import '../../theme/config/app_color.dart';

class CommonRefreshIndicator extends StatelessWidget {
  const CommonRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });
  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
