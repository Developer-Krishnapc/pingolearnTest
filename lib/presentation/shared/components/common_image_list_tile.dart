import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/extension/widget.dart';
import '../../../core/utils/app_utils.dart';
import '../../../domain/model/document_model.dart';
import '../../design/providers/design_notifier.dart';
import '../../hanger/provider/hanger_list_notifier.dart';
import '../../hanger/provider/hanger_notifier.dart';
import '../../printer/provider/printer_notifier.dart';
import '../../profile/providers/user_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';
import 'custom_dialog.dart';
import 'dummy_image_widget.dart';

class CommonImageListTile extends ConsumerWidget {
  const CommonImageListTile({
    super.key,
    required this.imageType,
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.imageList,
    this.isPrintPage,
    required this.isDeactivated,
  });
  final String imageType;

  final String name;
  final String imageUrl;
  final int id;
  final List<DocumentModel> imageList;
  final bool? isPrintPage;
  final bool isDeactivated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hangerNotifier = ref.read(hangerNotifierProvider.notifier);
    final designNotifier = ref.read(designNotifierProvider.notifier);
    final printNotifier = ref.read(printerNotifierProvider.notifier);
    final isStaff =
        ref.watch(userNotifierProvider.select((value) => value.data.role)) ==
            EntityType.staffRole;

    return InkWell(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: double.maxFinite,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: '$imageType$id',
                      child: (imageUrl.isEmpty)
                          ? const DummyImageWidget()
                          : CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, string, obj) {
                                return const DummyImageWidget();
                              },
                            ),
                    ),
                  ),
                ),
                const Gap(5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppTextTheme.label12.copyWith(
                          color: AppColor.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isPrintPage != true)
                      SizedBox(
                        width: 40,
                        height: 30,
                        child: PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: const Text('Edit'),
                              onTap: () async {
                                if (imageType == EntityType.designImage) {
                                  if (AppUtils.isAccessAllowed(
                                    moduleType: EntityType.designModule,
                                    accessType: EntityType.update,
                                    ref: ref,
                                  )) {
                                    await Future.wait([
                                      designNotifier.addSelectedImage(
                                        imageList
                                            .map(
                                              (e) => DocumentModel(
                                                id: e.id,
                                                modelId: id,
                                                url: e.url,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ]);
                                    // ignore: use_build_context_synchronously
                                    context
                                        .pushRoute(
                                          EditDesignRoute(
                                            heroTag: EntityType.designImage +
                                                id.toString(),
                                            id: id,
                                          ),
                                        )
                                        .whenComplete(
                                          () => designNotifier.clearData(),
                                        );
                                    designNotifier.setDesign(
                                      designId: id,
                                      fillData: true,
                                    );
                                  } else {
                                    AppUtils.flushBar(
                                      context,
                                      'No access to update design',
                                      isSuccessPopup: false,
                                    );
                                  }
                                } else {
                                  if (AppUtils.isAccessAllowed(
                                    moduleType: EntityType.hangerModule,
                                    accessType: EntityType.update,
                                    ref: ref,
                                  )) {
                                    await Future.wait([
                                      hangerNotifier.addSelectedImage(
                                        imageList
                                            .map(
                                              (e) => DocumentModel(
                                                id: e.id,
                                                modelId: id,
                                                url: e.url,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ]);

                                    // ignore: use_build_context_synchronously
                                    context
                                        .pushRoute(
                                          EditHangerRoute(
                                            heroTag: EntityType.hangerImage +
                                                id.toString(),
                                            id: id,
                                          ),
                                        )
                                        .whenComplete(
                                          () => hangerNotifier.clearData(),
                                        );
                                    hangerNotifier.setHanger(
                                      hangerId: id,
                                      fillData: true,
                                    );
                                  } else {
                                    AppUtils.flushBar(
                                      context,
                                      'No access to update hanger',
                                      isSuccessPopup: false,
                                    );
                                  }
                                }
                              },
                            ),
                            PopupMenuItem(
                              onTap: () {
                                if (imageType == EntityType.designImage) {
                                  if (AppUtils.isAccessAllowed(
                                    moduleType: EntityType.designModule,
                                    accessType: EntityType.delete,
                                    ref: ref,
                                  )) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final loadingState = ref.watch(
                                          designNotifierProvider
                                              .select((value) => value.loading),
                                        );
                                        return Consumer(
                                          builder: (context, ref, child) {
                                            return CustomDialog(
                                              isLoading: loadingState,
                                              title:
                                                  'Are you sure you want to delete the design?',
                                              onPositive: () async {
                                                designNotifier.deleteDesign(
                                                  designId: id,
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
                                      'No access to delete design',
                                      isSuccessPopup: false,
                                    );
                                  }
                                } else {
                                  if (AppUtils.isAccessAllowed(
                                    moduleType: EntityType.hangerModule,
                                    accessType: EntityType.delete,
                                    ref: ref,
                                  )) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final loadingState = ref.watch(
                                          hangerNotifierProvider
                                              .select((value) => value.loading),
                                        );
                                        return Consumer(
                                          builder: (context, ref, child) {
                                            return CustomDialog(
                                              isLoading: loadingState,
                                              title:
                                                  'Are you sure you want to delete the hanger?',
                                              onPositive: () async {
                                                final data =
                                                    await hangerNotifier
                                                        .deleteHanger(
                                                  hangerId: id,
                                                );
                                                if (data != null) {
                                                  // ignore: use_build_context_synchronously
                                                  AppUtils.flushBar(
                                                    context,
                                                    data,
                                                    isSuccessPopup: false,
                                                  );
                                                } else {
                                                  // ignore: use_build_context_synchronously
                                                  AppUtils.flushBar(
                                                    context,
                                                    'Hanger deleted successfully',
                                                  );
                                                }
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
                                      'No access to delete hanger',
                                      isSuccessPopup: false,
                                    );
                                  }
                                }
                              },
                              child: const Text('Delete'),
                            ),
                            PopupMenuItem(
                              child: const Text('Print'),
                              onTap: () {
                                if (imageType == EntityType.designImage) {
                                  context
                                      .pushRoute(
                                        PrinterRoute(
                                          moduleType: EntityType.designModule,
                                          id: id,
                                        ),
                                      )
                                      .whenComplete(
                                        () => printNotifier.clearData(),
                                      );
                                } else {
                                  context
                                      .pushRoute(
                                        PrinterRoute(
                                          moduleType: EntityType.hangerModule,
                                          id: id,
                                        ),
                                      )
                                      .whenComplete(
                                        () => printNotifier.clearData(),
                                      );
                                }
                              },
                            ),
                            if (imageType == EntityType.hangerImage)
                              PopupMenuItem(
                                child: const Text('Export PDF'),
                                onTap: () async {
                                  AppUtils.showDownloadingWidget(
                                      context: context);
                                  final data = await ref
                                      .read(hangerListNotifierProvider.notifier)
                                      .exportHangerPdf(hangerId: id);

                                  context.popRoute();
                                  if (data == null) {
                                    AppUtils.flushBar(
                                      context,
                                      'File Downloaded Successfully',
                                    );
                                  } else {
                                    AppUtils.flushBar(
                                      context,
                                      data,
                                      isSuccessPopup: false,
                                    );
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                  ],
                ).pad(
                  left: 15,
                  bottom: 10,
                ),
              ],
            ),
          ),
          if (!isStaff)
            Positioned(
              top: 0,
              left: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: isDeactivated ? AppColor.red : AppColor.green,
                ),
                child: Text(
                  isDeactivated ? 'In-Active' : 'Active',
                  style: AppTextTheme.label11.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                ).pad(left: 8, right: 8, top: 5, bottom: 5),
              ),
            ),
        ],
      ),
    );
  }
}
