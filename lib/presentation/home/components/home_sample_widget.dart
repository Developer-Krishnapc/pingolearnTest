import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/entity_type.dart';
import '../../design/providers/design_list_notifier.dart';
import '../../shared/components/app_loader.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/common_image_list_tile.dart';
import '../../theme/config/app_color.dart';

class HomeSampleWidget extends ConsumerWidget {
  const HomeSampleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemList = ref.watch(
      designListNotifierProvider.select((value) => value.data.designItemList),
    );
    final loadingState =
        ref.watch(designListNotifierProvider.select((value) => value.loading));

    final loadMore =
        ref.watch(designListNotifierProvider.select((value) => value.loadMore));

    final notifier = ref.read(designListNotifierProvider.notifier);
    if (loadingState) {
      return const SliverFillRemaining(
        child: Center(child: AppLoader()),
      );
    }
    if (itemList.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'No designs found',
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
          if (itemList.length - 1 == index && loadMore) {
            notifier.loadMore();
            return const AppLoader();
          }
          final item = itemList[index];
          return CommonImageListTile(
            isDeactivated: item.isDeactivated == 'Y',
            imageType: EntityType.designImage,
            imageUrl: item.images.isEmpty ? '' : item.images.first.url,
            id: item.id,
            name: item.millRefNo,
            imageList: item.images,
          );
        },
        childCount: itemList.length,
      ),
    );
  }
}
