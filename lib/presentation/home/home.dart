import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/extension/datetime.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/news_list_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../auth/providers/firebase_instance_provider.dart';
import '../news/providers/news_list_notifier.dart';
import '../routes/app_router.dart';
import '../shared/components/app_loader.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/common_refresh_indicator.dart';
import '../shared/components/custom_dialog.dart';
import '../shared/providers/router.dart';
import '../theme/config/app_color.dart';
import 'components/home_app_bar.dart';
import 'components/news_list_tile.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ProviderSubscription? _designSubscription;
  @override
  void initState() {
    _designSubscription = ref.listenManual<PaginationState<NewsListModel>>(
        newsListNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final designState = ref.read(
        newsListNotifierProvider.select((value) => value.data.newList),
      );
      if (designState.isEmpty) {
        final notifier = ref.read(newsListNotifierProvider.notifier);
        notifier.reset();
        notifier.getNewsList();
      }
    });
  }

  @override
  void dispose() {
    _designSubscription?.close();
    super.dispose();
  }

//
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(newsListNotifierProvider.notifier);
    final state = ref.watch(newsListNotifierProvider);
    return Scaffold(
      appBar: const HomeAppBar(),
      backgroundColor: AppColor.lightBackground,
      body: Container(
        color: AppColor.primary,
        child: SafeArea(
          child: Container(
            color: AppColor.lightBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Text(
                  'Top Headlines',
                  style: AppTextTheme.label14.copyWith(
                      color: AppColor.black, fontWeight: FontWeight.bold),
                ),
                const Gap(15),
                Expanded(
                  child: CommonRefreshIndicator(
                    onRefresh: () async {
                      notifier.reset();
                      notifier.getNewsList();
                    },
                    child: (state.loading)
                        ? const Center(
                            child: AppLoader(),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Gap(10);
                            },
                            itemBuilder: (context, index) {
                              final item = state.data.newList[index];
                              if (state.data.newList.length - 1 == index &&
                                  state.loadMore) {
                                notifier.loadMore();
                                return const AppLoader();
                              }

                              return NewsListTileWidget(
                                title: item.title,
                                description: item.description,
                                imageUrl: item.imageUrl ?? '',
                                time: DateTime.now().toHHMM(),
                                publishedAt: item.publishedAt ?? '',
                              );
                            },
                            itemCount: state.data.newList.length,
                          ),
                  ),
                ),
              ],
            ).padHor(15),
          ),
        ),
      ),
    );
  }
}
