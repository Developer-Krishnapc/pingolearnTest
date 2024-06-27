import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../shared/components/app_loader.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/common_image_list_tile.dart';
import '../../theme/config/app_color.dart';
import '../provider/hanger_list_notifier.dart';

class HangerListWidget extends ConsumerStatefulWidget {
  const HangerListWidget({
    super.key,
  });

  @override
  ConsumerState<HangerListWidget> createState() => _HangerListWidgetState();
}

class _HangerListWidgetState extends ConsumerState<HangerListWidget> {
  @override
  Widget build(BuildContext context) {
    final itemList = ref.watch(
      hangerListNotifierProvider.select((value) => value.data.hangerItemList),
    );
    final loadingState =
        ref.watch(hangerListNotifierProvider.select((value) => value.loading));

    final loadMore =
        ref.watch(hangerListNotifierProvider.select((value) => value.loadMore));

    final notifier = ref.read(hangerListNotifierProvider.notifier);

    if (loadingState) {
      return const SliverFillRemaining(
        child: Center(child: AppLoader()),
      );
    }
    if (itemList.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'No hangers found',
            style: AppTextTheme.label14.copyWith(color: AppColor.primary),
          ),
        ),
      );
    }
    return SliverGrid(
      key: const PageStorageKey('HangerList'),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 205,
        mainAxisSpacing: 15,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (itemList.length - 1 == index && loadMore) {
            notifier.loadMore();
            return const AppLoader();
          }
          final item = itemList[index];
          return CommonImageListTile(
            imageType: EntityType.hangerImage,
            imageUrl: item.images.isEmpty ? '' : item.images.first.url,
            isDeactivated: item.isDeactivated == 'Y',
            id: item.id,
            name: item.name,
            imageList: item.images,
          );
        },
        childCount: itemList.length,
      ),
    );
  }
}
