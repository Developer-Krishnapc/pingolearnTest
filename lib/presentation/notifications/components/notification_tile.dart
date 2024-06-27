import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/extension/datetime.dart';
import '../../../core/extension/widget.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/gen/assets.gen.dart';
import '../../theme/app_style.dart';
import '../../theme/config/app_color.dart';

class NotificationTile extends ConsumerStatefulWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.createdDate,
    required this.message,
    required this.isRead,
  });
  final String title;
  final String createdDate;
  final String message;
  final bool isRead;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationTileState();
}

class _NotificationTileState extends ConsumerState<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    final DateTime? date = widget.createdDate.isEmpty
        ? null
        : DateFormat('yyyy-MM-dd hh:mm:ss').parse(widget.createdDate);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppStyle.shadow,
        color: !widget.isRead ? AppColor.lightGrey : AppColor.white,
        border: Border.all(
          color: AppColor.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Assets.icons.logo.image(height: 30),
          const Gap(10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: AppTextTheme.semiBold14),
                Text(
                  widget.message,
                  style: AppTextTheme.label12.copyWith(color: AppColor.grey),
                ),
              ],
            ),
          ),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                date?.toDDMMYY() ?? '',
                style: AppTextTheme.label12,
              ),
              Text(
                date != null ? DateFormat.jm().format(date) : '',
                style: AppTextTheme.label12,
              ),
            ],
          ),
        ],
      ).padAll(10),
    );
  }
}
