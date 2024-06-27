import 'package:flutter/material.dart';

import '../../theme/config/app_color.dart';
import '../gen/assets.gen.dart';
import 'app_text_theme.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, this.ctrl, this.hintText});
  final TextEditingController? ctrl;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Assets.svg.searchIcon.svg(color: AppColor.black, height: 20),
          Expanded(
            child: TextFormField(
              controller: ctrl,
              style: AppTextTheme.label12,
              cursorColor: AppColor.primary,
              decoration: InputDecoration(
                hintText: hintText ?? 'Search here',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: AppTextTheme.label12,
                labelStyle: AppTextTheme.label11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
