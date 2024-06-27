import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notifications/provider/notification_list_notifier.dart';
import '../../routes/app_router.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/gen/assets.gen.dart';
import '../../theme/config/app_color.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.appBarTitle});
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: appBarTitle,
                style:
                    AppTextTheme.semiBold18.copyWith(color: AppColor.primary),
              ),
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        Consumer(
          builder: (context, ref, child) {
            final isNotificationPending = ref.watch(
              notificationListNotifierProvider
                  .select((value) => value.data.isReadPending),
            );
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    context
                        .pushRoute(const NotificationRoute())
                        .whenComplete(() {
                      ref
                          .read(notificationListNotifierProvider.notifier)
                          .updateNotificationRead();
                    });
                  },
                  child: Assets.svg.notificationIcon.svg(),
                ),
                if (isNotificationPending)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: AppColor.red,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
