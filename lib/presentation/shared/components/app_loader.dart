import 'package:flutter/material.dart';

import '../../theme/config/app_color.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.loaderColor});
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: loaderColor ?? AppColor.primary,
      ),
    );
  }
}
