import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';
import 'custom_filled_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.title,
    this.onPositive,
    this.onNegative,
    this.height,
    this.isLoading,
  }) : super(key: key);
  final String title;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final double? height;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      // shadowColor: AppColor.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(15),
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1C000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        // color: AppColor.white,

        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextTheme.semiBold16,
              textAlign: TextAlign.center,
            ).padHor(10),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: CustomFilledButton(
                    isLoading: isLoading,
                    title: 'Yes',
                    onTap:(isLoading!=true)? onPositive:null,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: CustomFilledButton(
                    title: 'No',
                    onTap:isLoading!=true? onNegative ?? () => context.popRoute():null,
                    color: AppColor.darkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
