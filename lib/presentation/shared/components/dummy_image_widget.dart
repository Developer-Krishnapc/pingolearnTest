import 'package:flutter/material.dart';

import '../../theme/config/app_color.dart';
import '../gen/assets.gen.dart';

class DummyImageWidget extends StatelessWidget {
  const DummyImageWidget({super.key, this.height, this.width});
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: AppColor.emptyBgGrey,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Assets.icons.images.duratexLogo
              .image(height: 50, color: AppColor.darkGrey),
        ),
      ),
    );
  }
}
