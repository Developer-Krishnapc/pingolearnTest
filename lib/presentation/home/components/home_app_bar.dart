import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../auth/providers/firebase_instance_provider.dart';
import '../../routes/app_router.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/custom_dialog.dart';
import '../../shared/providers/app_content.dart';
import '../../shared/providers/router.dart';
import '../../theme/config/app_color.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.read(appContentProvider).countryCode;
    return AppBar(
      backgroundColor: AppColor.primary,
      title: Text(
        'My News',
        style: AppTextTheme.label14
            .copyWith(color: AppColor.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.location_fill,
              color: AppColor.white,
            ),
            const Gap(5),
            Text(
              country.toUpperCase(),
              style: AppTextTheme.label14
                  .copyWith(color: AppColor.white, fontWeight: FontWeight.bold),
            ),
            const Gap(35),
            InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog(
                        title: 'Are you sure you want to Logout ?',
                        onPositive: () async {
                          ref.read(firebaseAuthInstanceProvider).signOut();
                          ref.read(routerProvider).replaceAll([LoginRoute()]);
                        },
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.logout,
                  color: AppColor.white,
                ))
          ],
        ).padRight(15)
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
