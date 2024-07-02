import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';

class DropdownConatinerWidget extends StatelessWidget {
  const DropdownConatinerWidget({
    super.key,
    required this.onTap,
    required this.selectedValue,
    required this.errorString,
    required this.isMandatory,
  });
  final VoidCallback onTap;
  final String selectedValue;
  final String errorString;
  final bool isMandatory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.white,
              border: Border.all(
                color: (selectedValue.isEmpty && isMandatory)
                    ? AppColor.red
                    : AppColor.bluishGrey,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedValue,
                    overflow: TextOverflow.fade,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor.bluishGrey,
                ),
              ],
            ),
          ),
          if (selectedValue.isEmpty && isMandatory)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(10),
                Text(
                  errorString,
                  style: AppTextTheme.label11.copyWith(color: AppColor.red),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
