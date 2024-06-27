import 'package:flutter/material.dart';

import '../../theme/config/app_color.dart';
import '../gen/assets.gen.dart';
import 'app_text_theme.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.onChanged,
    required this.items,
    this.selected,
    required this.title,
    this.validator,
    this.hintText,
    this.hintStyle,
    this.selectedItemHeight,
  });

  final void Function(T? item) onChanged;
  final String Function(T item) title;
  final List<T> items;
  final T? selected;
  final String? Function(T?)? validator;
  final String? hintText;
  final TextStyle? hintStyle;
  final double? selectedItemHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        value: selected,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        iconSize: selectedItemHeight ?? 0,
        icon: Assets.svg.arrowDown.svg(width: 12),
        style: AppTextTheme.label14,
        decoration: InputDecoration(
          hintStyle: hintStyle ??
              AppTextTheme.label14.copyWith(
                color: AppColor.bluishGrey,
                overflow: TextOverflow.ellipsis,
              ),
          hintText: hintText,
          border: InputBorder.none,
          errorStyle: AppTextTheme.label12.copyWith(color: AppColor.red),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.lightGrey,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.lightGrey,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.lightGrey,
            ),
          ),
        ),
        items: List.generate(
          items.length,
          (index) {
            final current = items[index];
            return DropdownMenuItem<T>(
              value: current,
              child: Text(
                title(current),
                style: AppTextTheme.label13,
                overflow: TextOverflow.clip,
              ),
            );
          },
        ),
        onChanged: onChanged,
      ),
    );
  }
}
