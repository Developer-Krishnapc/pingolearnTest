import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../design/components/sample_pages_app_bar.dart';
import '../gen/assets.gen.dart';
import 'profile_image_edit_widget.dart';

class ProfileBackgroundWidget extends StatelessWidget {
  const ProfileBackgroundWidget({
    super.key,
    required this.pageTitle,
    this.actionWidget,
    required this.imageWidget,
  });
  final String pageTitle;
  final Widget? actionWidget;
  final ProfileImageEditWidget imageWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.maxFinite,
                  child: Assets.icons.images.profileBackground
                      .image(fit: BoxFit.cover),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white60,
                        Colors.white60,
                        Colors.white30,
                      ],
                    ),
                  ),
                  height: 220,
                  width: double.maxFinite,
                ),
              ],
            ),
            const Gap(20),
          ],
        ),
        SafeArea(
          child: Column(
            children: [
              SamplePageAppBar(
                title: pageTitle,
                actionWidget: actionWidget,
              ),
              const Gap(40),
              imageWidget,
              const Gap(30),
            ],
          ),
        ).padHor(15),
      ],
    );
  }
}
