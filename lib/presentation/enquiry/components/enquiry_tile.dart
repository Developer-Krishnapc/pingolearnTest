import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/extension/widget.dart';
import '../../../core/utils/app_utils.dart';
import '../../../domain/model/enquiry_model.dart';
import '../../routes/app_router.dart';
import '../../shared/components/change_date_time.dart';
import '../../shared/components/content_detail_widget.dart';
import '../../shared/components/custom_dialog.dart';
import '../../shared/components/dummy_image_widget.dart';
import '../../theme/app_style.dart';
import '../../theme/config/app_color.dart';
import '../provider/enquiry_notifier.dart';

class EnquiryTile extends ConsumerWidget {
  const EnquiryTile({
    super.key,
    required this.enquiryItem,
    required this.enquiryDate,
  });
  final EnquiryItem enquiryItem;
  final String enquiryDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(enquiryNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.white,
        boxShadow: AppStyle.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 150,
              width: double.maxFinite,
              child: (enquiryItem.image.isEmpty)
                  ? const DummyImageWidget()
                  : CachedNetworkImage(
                      imageUrl: enquiryItem.image,
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: ContentDetailWidget(
                  titleName: 'Date',
                  description: changeToDMYHmsHyphen(enquiryDate),
                ),
              ),
              Expanded(
                flex: 2,
                child: ContentDetailWidget(
                  titleName: 'Status',
                  description: enquiryItem.statusName,
                  textColor: AppColor.green,
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () {
                          if (AppUtils.isAccessAllowed(
                            moduleType: EntityType.enquiryModule,
                            accessType: EntityType.update,
                            ref: ref,
                          )) {
                            notifier.setEnquiryItem(data: enquiryItem);
                            notifier.getEnquiryItemList(
                              enquiryId: enquiryItem.enquiryId,
                            );

                            context
                                .pushRoute(
                                  AddEnquiryRoute(
                                    isUpdate: true,
                                    enquiryId: enquiryItem.enquiryId,
                                  ),
                                )
                                .whenComplete(() => notifier.clearData());
                          } else {
                            AppUtils.flushBar(
                              context,
                              'No access to update enquiry',
                              isSuccessPopup: false,
                            );
                          }
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () {
                          if (AppUtils.isAccessAllowed(
                            moduleType: EntityType.enquiryModule,
                            accessType: EntityType.delete,
                            ref: ref,
                          )) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                final loadingState = ref.watch(
                                  enquiryNotifierProvider
                                      .select((value) => value.loading),
                                );
                                return Consumer(
                                  builder: (context, ref, child) {
                                    return CustomDialog(
                                      isLoading: loadingState,
                                      title:
                                          'Are you sure you want to delete the enquiry?',
                                      onPositive: () async {
                                        notifier.deleteEnquiry(
                                          enquiryId: enquiryItem.enquiryId,
                                        );
                                        AppUtils.flushBar(
                                          context,
                                          'Enquiry deleted successfully',
                                        );
                                        context.popRoute();
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            AppUtils.flushBar(
                              context,
                              'No access to delete enquiry',
                              isSuccessPopup: false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).pad(left: 15, right: 15, top: 15, bottom: 10),
          ContentDetailWidget(
            titleName: 'Username',
            description: enquiryItem.name,
          ).pad(left: 15, right: 15, bottom: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 20,
            ),
            child: ContentDetailWidget(
              titleName: 'Comments',
              maxLine: 3,
              description: enquiryItem.description,
            ).pad(left: 15, right: 15, bottom: 15),
          ),
        ],
      ),
    );
  }
}
