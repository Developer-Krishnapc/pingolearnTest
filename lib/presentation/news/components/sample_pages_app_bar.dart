import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/icon_button.dart';
import '../../theme/config/app_color.dart';

class SamplePageAppBar extends StatelessWidget {
  const SamplePageAppBar({
    super.key,
    required this.title,
    this.onBackPress,
    this.actionWidget,
  });
  final String title;
  final VoidCallback? onBackPress;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBackPress ??
              () {
                context.popRoute();
              },
          child: CustomIconButton(
            backgroundColor: AppColor.primary,
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.white,
              size: 15,
            ).padLeft(5),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextTheme.semiBold18,
          ),
        ),
        if (actionWidget == null) const Gap(25),
        actionWidget ?? const SizedBox(),
      ],
    ).pad(top: 15);
  }
}
