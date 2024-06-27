import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/common_stats_model.dart';
import '../../theme/app_style.dart';
import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';

class CommonStatsWidget extends ConsumerWidget {
  const CommonStatsWidget({super.key, required this.statsData});
  final List<CommonStatsModel> statsData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          statsData.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            decoration: BoxDecoration(
              boxShadow: AppStyle.shadow,
              color: AppColor.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  statsData[index].count.toString(),
                  style: AppTextTheme.semiBold20.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
                Text(
                  statsData[index].name,
                  textAlign: TextAlign.center,
                  style:
                      AppTextTheme.semiBold12.copyWith(color: AppColor.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
