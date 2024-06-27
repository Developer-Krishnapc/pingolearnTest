import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/entity_type.dart';
import '../../core/extension/widget.dart';
import '../routes/app_router.dart';
import '../shared/components/app_loader.dart';
import '../shared/components/common_refresh_indicator.dart';
import '../shared/components/content_detail_widget.dart';
import '../shared/components/profile_background_widget.dart';
import '../shared/components/profile_image_edit_widget.dart';
import '../theme/config/app_color.dart';
import 'providers/user_notifier.dart';

@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userId =
          ref.read(userNotifierProvider.select((value) => value.data.id));
      ref.read(userNotifierProvider.notifier).getUserById(userId: userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider.select((value) => value.data));
    final notifier = ref.read(userNotifierProvider.notifier);
    final loading =
        ref.watch(userNotifierProvider.select((value) => value.loading));
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      body: SafeArea(
        top: false,
        child: CommonRefreshIndicator(
          onRefresh: () async {
            notifier.getUserById(userId: state.id);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ProfileBackgroundWidget(
                  pageTitle: 'Profile',
                  actionWidget: SizedBox(
                    width: 40,
                    height: 30,
                    child: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () {
                            context.pushRoute(
                              const EditProfileRoute(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  imageWidget: ProfileImageEditWidget(
                    imageUrl: state.profileImage.url,
                    selectedImagePath: '',
                  ),
                ),
                if (loading) const AppLoader().pad(top: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
