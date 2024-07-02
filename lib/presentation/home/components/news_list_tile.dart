import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/utils/app_utils.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/gen/assets.gen.dart';
import '../../theme/config/app_color.dart';

class NewsListTileWidget extends StatelessWidget {
  const NewsListTileWidget(
      {super.key,
      required this.time,
      required this.description,
      required this.imageUrl,
      required this.publishedAt,
      required this.title});
  final String title;
  final String description;
  final String time;
  final String imageUrl;

  final String publishedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: AppColor.white),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        style: AppTextTheme.label12.copyWith(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.fade),
                        maxLines: 2,
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      flex: 6,
                      child: Text(
                        description,
                        maxLines: 3,
                        style: AppTextTheme.label12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      AppUtils.timeDifference(
                          dateTime:
                              DateTime.tryParse(publishedAt) ?? DateTime.now()),
                      style:
                          AppTextTheme.label11.copyWith(color: AppColor.grey),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
                const Gap(10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 100,
                    height: 105,
                    child: (imageUrl.isEmpty)
                        ? Assets.icons.images.dummyNewsIcon
                            .image(fit: BoxFit.cover)
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, string, data) {
                              return Assets.icons.images.dummyNewsIcon
                                  .image(fit: BoxFit.cover);
                            },
                          ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
