import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/entity_type.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../data/model/common_stats_model.dart';
import '../../domain/model/design_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../design/providers/design_list_notifier.dart';
import '../notifications/provider/notification_list_notifier.dart';
import '../printer/provider/printer_notifier.dart';
import '../routes/app_router.dart';
import '../shared/components/common_refresh_indicator.dart';
import '../shared/components/common_stats_widget.dart';
import '../shared/components/icon_button.dart';
import '../shared/components/search_widget.dart';
import '../shared/gen/assets.gen.dart';
import '../theme/config/app_color.dart';
import 'components/design_filter_widget.dart';
import 'components/home_app_bar.dart';
import 'components/home_sample_widget.dart';

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
    _designSubscription = ref.listenManual<PaginationState<DesignListModel>>(
        designListNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final designState = ref.read(
        designListNotifierProvider.select((value) => value.data.designItemList),
      );
      if (designState.isEmpty) {
        final notifier = ref.read(designListNotifierProvider.notifier);
        notifier.reset();
        notifier.getDesignList();
      }

      ref
          .read(notificationListNotifierProvider.notifier)
          .getUnreadPendingCount();
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
    // final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(designListNotifierProvider.notifier);
    ref.read(notificationListNotifierProvider);
    final isFilterApplied = ref.watch(
      designListNotifierProvider.select((value) => value.data.isFilterApplied),
    );
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final printNotifier = ref.read(printerNotifierProvider.notifier);
    return Scaffold(
      drawer: const DesignFilterDrawer(),
      backgroundColor: AppColor.whiteBackground,
      floatingActionButton: (!isKeyboardOpen)
          ? FloatingActionButton(
              heroTag: 'HOME',
              onPressed: () {
                if (AppUtils.isAccessAllowed(
                  moduleType: EntityType.designModule,
                  accessType: EntityType.create,
                  ref: ref,
                )) {
                  context.pushRoute(AddSampleRoute());
                } else {
                  AppUtils.flushBar(
                    context,
                    'No access to create design',
                    isSuccessPopup: false,
                  );
                }
              },
              shape: const CircleBorder(),
              backgroundColor: AppColor.black,
              child: const Icon(
                Icons.add,
                color: AppColor.white,
              ),
            )
          : null,
      body: SafeArea(
        child: CommonRefreshIndicator(
          onRefresh: () async {
            notifier.reset();
            notifier.getStatsData();

            notifier.getDesignList();

            ref
                .read(notificationListNotifierProvider.notifier)
                .getUnreadPendingCount();
          },
          child: CustomScrollView(
            slivers: [
              const SliverGap(20),
              const SliverToBoxAdapter(
                child: HomeAppBar(
                  appBarTitle: 'Design',
                ),
              ),
              const SliverGap(20),
              SliverToBoxAdapter(
                child: Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final homeStats = ref.watch(
                        designListNotifierProvider
                            .select((value) => value.data.stats),
                      );
                      return CommonStatsWidget(
                        statsData: [
                          CommonStatsModel(
                            name: 'Total\nDesign',
                            count: homeStats.totalDesign,
                          ),
                          CommonStatsModel(
                            name: 'Total\nHanger',
                            count: homeStats.totalHanger,
                          ),
                          CommonStatsModel(
                            name: 'Total\nEnquiry',
                            count: homeStats.totalEnquiry,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SliverGap(20),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: SearchWidget(
                        ctrl: notifier.searchCtrl,
                      ),
                    ),
                    const Gap(8),
                    Stack(
                      children: [
                        Builder(
                          builder: (context) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).nextFocus();
                                Scaffold.of(context).openDrawer();
                              },
                              child: CustomIconButton(
                                icon: Assets.svg.filterIcon.svg(),
                                backgroundColor: AppColor.primary,
                              ),
                            ).padAll(2);
                          },
                        ),
                        if (isFilterApplied)
                          const Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: AppColor.red,
                            ),
                          ),
                      ],
                    ),
                    const Gap(5),
                    SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          icon: const Align(
                            child: Icon(
                              Icons.more_vert,
                              color: AppColor.white,
                              size: 25,
                            ),
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: const Text('Print'),
                              onTap: () {
                                context
                                    .pushRoute(
                                      PrinterRoute(
                                        moduleType: EntityType.designModule,
                                      ),
                                    )
                                    .whenComplete(
                                      () => printNotifier.clearData(),
                                    );
                              },
                            ),
                            PopupMenuItem(
                              child: const Text('Export Excel'),
                              onTap: () async {
                                final data = await notifier.exportDesign();
                                if (data == null) {
                                  // ignore: use_build_context_synchronously
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
                    ),
                  ],
                ),
              ),
              const SliverGap(20),
              const HomeSampleWidget(),
              const SliverGap(80),
            ],
          ).pad(
            left: 15,
            right: 15,
          ),
        ),
      ),
    );
  }
}
