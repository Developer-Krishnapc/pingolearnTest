import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';

class ContentDetailWidget extends StatelessWidget {
  const ContentDetailWidget({
    super.key,
    required this.titleName,
    required this.description,
    this.maxLine,
    this.textColor,
  });
  final String titleName;
  final String description;
  final int? maxLine;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleName,
          style: AppTextTheme.label13.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColor.bluishGrey,
          ),
        ),
        const Gap(8),
        Text(
          description,
          style: AppTextTheme.label13.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor ?? AppColor.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: maxLine ?? 1,
        ),
      ],
    );
  }
}
