import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/extension/widget.dart';
import '../../../domain/model/enquiry_model.dart';
import '../../routes/app_router.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/dummy_image_widget.dart';
import '../../theme/config/app_color.dart';
import '../provider/enquiry_notifier.dart';
import 'enquiry_status_update_widget.dart';

class EnquiryDesignGridWidget extends ConsumerWidget {
  const EnquiryDesignGridWidget({super.key, required this.enquiryItems});

  final List<EnquiryItem> enquiryItems;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(enquiryNotifierProvider.notifier);
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 200,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = enquiryItems[index];
          final isHanger = item.hanger != null;
          final hangerImg = isHanger
              ? item.hanger?.images.isEmpty == true
                  ? ''
                  : item.hanger?.images.first.url ?? ''
              : '';
          final designImg = !isHanger
              ? item.design?.images.isEmpty == true
                  ? ''
                  : item.design?.images.first.url ?? ''
              : '';

          return InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ((hangerImg + designImg).isEmpty)
                            ? const DummyImageWidget(
                                height: 148,
                                width: double.maxFinite,
                              )
                            : SizedBox(
                                height: 148,
                                width: double.maxFinite,
                                child: CachedNetworkImage(
                                  imageUrl: hangerImg + designImg,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Positioned(
                        top: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: (item.status?.code == 'PENDING')
                                ? AppColor.orange
                                : AppColor.green,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            item.status?.name ?? '',
                            style: AppTextTheme.label12.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (isHanger
                                  ? item.hanger?.name
                                  : item.design?.millRefNo) ??
                              '',
                          style: AppTextTheme.label12.copyWith(
                            color: AppColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 30,
                        child: PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return EnquiryStatusUpdateWidget(
                                      uniqueId: item.uniqueId,
                                    );
                                  },
                                );
                              },
                              child: const Text('Update Status'),
                            ),
                            PopupMenuItem(
                              child: const Text('Remove'),
                              onTap: () {
                                notifier.removeEnquiryItemId(
                                  uniqueId: item.uniqueId,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).pad(
                    left: 15,
                  ),
                ],
              ),
            ),
          );
        },
        childCount: enquiryItems.length,
      ),
    );
  }
}
