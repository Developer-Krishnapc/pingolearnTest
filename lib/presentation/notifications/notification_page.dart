import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/extension/widget.dart';
import '../design/components/sample_pages_app_bar.dart';
import '../theme/config/app_color.dart';
import 'components/notification_list.dart';
import 'provider/notification_list_notifier.dart';

@RoutePage()
class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationPageState();
}

final linkProvider = StateProvider<bool>((ref) {
  return false;
});

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(notificationListNotifierProvider.notifier).reset();
      await ref
          .read(notificationListNotifierProvider.notifier)
          .getNotificationList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final notificationState = ref.watch(notificationHistoryProvider);

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: const Column(
          children: [
            SamplePageAppBar(title: 'Notification'),
            Gap(20),
            Expanded(child: NotificationList()),
          ],
        ).padHor(15),
      ),
    );
  }
}
