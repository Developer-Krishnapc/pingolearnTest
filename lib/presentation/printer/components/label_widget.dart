import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../shared/components/app_loader.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/common_image_list_tile.dart';
import '../../theme/config/app_color.dart';
import '../provider/printer_notifier.dart';

class LabelGridWidget extends ConsumerStatefulWidget {
  const LabelGridWidget({
    super.key,
    required this.moduleType,
    this.id,
    this.hangerId,
  });

  final String moduleType;
  final int? id;
  final int? hangerId;

  @override
  ConsumerState<LabelGridWidget> createState() => _LabelGridWidgetState();
}

class _LabelGridWidgetState extends ConsumerState<LabelGridWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final notifier = ref.read(printerNotifierProvider.notifier);
      if (widget.moduleType == EntityType.hangerModule) {
        notifier.getHangers(id: widget.id);
      } else {
        if (widget.hangerId != null) {
          notifier.getDesignByHangerId(hangerId: widget.hangerId!);
        } else {
          notifier.getDesigns(id: widget.id);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final printData =
        ref.watch(printerNotifierProvider.select((value) => value.data));
    final loadingState = ref.watch(
      printerNotifierProvider.select((value) => value.data.itemLoader),
    );
    if (loadingState) {
      return const SliverFillRemaining(
        child: Center(child: AppLoader()),
      );
    }
    if (printData.hangerList.isEmpty && printData.designList.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'No Data found',
            style: AppTextTheme.label14.copyWith(color: AppColor.primary),
          ),
        ),
      );
    }
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 200,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final hangerListItem = printData.hangerList.length - 1 < index
              ? null
              : printData.hangerList[index];
          final designListItem = printData.designList.length - 1 < index
              ? null
              : printData.designList[index];
          return CommonImageListTile(
            isDeactivated: hangerListItem != null
                ? hangerListItem.isDeactivated == 'Y'
                : designListItem?.isDeactivated == 'Y',
            isPrintPage: true,
            imageType: hangerListItem == null
                ? EntityType.designImage
                : EntityType.hangerImage,
            imageUrl: (hangerListItem?.images.isEmpty == true
                    ? ''
                    : hangerListItem?.images.first.url) ??
                (designListItem?.images.isEmpty == true
                    ? ''
                    : designListItem?.images.first.url) ??
                '',
            id: hangerListItem?.id ?? designListItem?.id ?? 0,
            name: hangerListItem?.name ?? designListItem?.millRefNo ?? '',
            imageList: [
              ...hangerListItem?.images ?? [],
              ...designListItem?.images ?? [],
            ],
          );
        },
        childCount: printData.designList.length + printData.hangerList.length,
      ),
    );
  }
}
