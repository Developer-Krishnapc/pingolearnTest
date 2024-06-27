import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/context.dart';
import '../../shared/components/app_loader.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/common_refresh_indicator.dart';
import '../../theme/config/app_color.dart';
import '../provider/notification_list_notifier.dart';
import 'notification_tile.dart';

class NotificationList extends ConsumerStatefulWidget {
  const NotificationList({
    super.key,
  });
  @override
  ConsumerState<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends ConsumerState<NotificationList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(notificationListNotifierProvider);

    if (result.loading) {
      return const AppLoader();
    }

    return (result.data.notificationList.isEmpty)
        ? CommonRefreshIndicator(
            onRefresh: () async {
              ref
                  .read(
                    notificationListNotifierProvider.notifier,
                  )
                  .reset();
              await ref
                  .read(notificationListNotifierProvider.notifier)
                  .getNotificationList();
            },
            child: SizedBox(
              height: context.heightByPercent(70),
              child: Center(
                child: Text(
                  'No notifications yet',
                  style: AppTextTheme.label14.copyWith(color: AppColor.primary),
                ),
              ),
            ),
          )
        : CommonRefreshIndicator(
            onRefresh: () async {
              ref
                  .read(
                    notificationListNotifierProvider.notifier,
                  )
                  .reset();
              await ref
                  .read(
                    notificationListNotifierProvider.notifier,
                  )
                  .getNotificationList();
            },
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Gap(10);
              },
              itemBuilder: (context, index) {
                final item = result.data.notificationList[index];
                if (result.data.notificationList.length - 1 == index &&
                    result.loadMore) {
                  ref
                      .read(
                        notificationListNotifierProvider.notifier,
                      )
                      .loadMore();
                  return const AppLoader();
                }

                return NotificationTile(
                  title: item.title,
                  message: item.description,
                  createdDate: item.date,
                  isRead: item.isRead == 'Y',
                );
              },
              itemCount: result.data.notificationList.length,
            ),
          );
  }
}
