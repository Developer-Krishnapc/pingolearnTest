import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/entity_type.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../data/model/common_stats_model.dart';
import '../../domain/model/enquiry_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../home/components/home_app_bar.dart';
import '../routes/app_router.dart';
import '../shared/components/app_loader.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/common_refresh_indicator.dart';
import '../shared/components/common_stats_widget.dart';
import '../shared/components/icon_button.dart';
import '../shared/components/search_widget.dart';
import '../shared/gen/assets.gen.dart';
import '../theme/config/app_color.dart';
import 'components/enquiry_filter.dart';
import 'components/enquiry_tile.dart';
import 'provider/enquiry_list_notifier.dart';
import 'provider/enquiry_notifier.dart';

@RoutePage()
class EnquiryPage extends ConsumerStatefulWidget {
  const EnquiryPage({super.key});

  @override
  ConsumerState<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends ConsumerState<EnquiryPage> {
  ProviderSubscription? _enquirySubscription;

  @override
  void initState() {
    _enquirySubscription = ref.listenManual<PaginationState<EnquiryListModel>>(
        enquiryListNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final enquiryState = ref.read(
        enquiryListNotifierProvider.select((value) => value.data.enquiryList),
      );
      if (enquiryState.isEmpty) {
        final notifier = ref.read(enquiryListNotifierProvider.notifier);
        notifier.reset();
        notifier.getEnquiryList();
      }
    });
  }

  @override
  void dispose() {
    _enquirySubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final notifier = ref.read(enquiryListNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      floatingActionButton: (!isKeyboardOpen)
          ? FloatingActionButton(
              heroTag: 'Enquiry',
              key: const ValueKey('enquiry_page_fab'),
              onPressed: () {
                if (AppUtils.isAccessAllowed(
                  moduleType: EntityType.enquiryModule,
                  accessType: EntityType.create,
                  ref: ref,
                )) {
                  context
                      .pushRoute(AddEnquiryRoute(isUpdate: false))
                      .whenComplete(
                        () => ref
                            .read(enquiryNotifierProvider.notifier)
                            .clearData(),
                      );
                } else {
                  AppUtils.flushBar(
                    context,
                    'No access to create enquiry',
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
        child: Column(
          children: [
            const Gap(20),
            const HomeAppBar(appBarTitle: 'Enquiry History'),
            const Gap(20),
            Consumer(
              builder: (context, ref, child) {
                final enquiryStats = ref.watch(
                  enquiryListNotifierProvider
                      .select((value) => value.data.enquiryStats),
                );
                return CommonStatsWidget(
                  statsData: [
                    CommonStatsModel(
                      name: 'Pending\n',
                      count: enquiryStats.pending,
                    ),
                    CommonStatsModel(
                      name: 'New\nEnquiry',
                      count: enquiryStats.newEnquiry,
                    ),
                    CommonStatsModel(
                      name: 'In\nProgress',
                      count: enquiryStats.inProgress,
                    ),
                    CommonStatsModel(
                      name: 'Completed\n',
                      count: enquiryStats.completed,
                    ),
                  ],
                );
              },
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: SearchWidget(
                    ctrl: notifier.nameCtrl,
                    hintText: 'Search by name',
                  ),
                ),
                const Gap(8),
                Consumer(
                  builder: (context, ref, child) {
                    final isFilterApplied = ref.watch(
                      enquiryListNotifierProvider
                          .select((value) => value.data.isFilterApplied),
                    );
                    return Stack(
                      children: [
                        Builder(
                          builder: (context) {
                            return InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return const EnquiryFilter();
                                  },
                                );
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
                    );
                  },
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
                          child: const Text('Export Excel'),
                          onTap: () async {
                            final data = await notifier.exportEnquiry();
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
                ),
              ],
            ),
            const Gap(20),
            Expanded(
              child: CommonRefreshIndicator(
                onRefresh: () async {
                  final notifier =
                      ref.read(enquiryListNotifierProvider.notifier);
                  notifier.reset();
                  notifier.getEnquiryList();
                  notifier.getEnquiryStats();
                },
                child: Consumer(
                  builder: (context, ref, child) {
                    final itemList = ref.watch(
                      enquiryListNotifierProvider
                          .select((value) => value.data.enquiryList),
                    );
                    final loadingState = ref.watch(
                      enquiryListNotifierProvider
                          .select((value) => value.loading),
                    );

                    final loadMore = ref.watch(
                      enquiryListNotifierProvider
                          .select((value) => value.loadMore),
                    );

                    final notifier =
                        ref.read(enquiryListNotifierProvider.notifier);

                    if (loadingState) {
                      return const AppLoader();
                    }
                    if (itemList.isEmpty) {
                      return Center(
                        child: Text(
                          'No Enquiry found',
                          style: AppTextTheme.label14
                              .copyWith(color: AppColor.primary),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: itemList.length,
                      itemBuilder: (context, index) {
                        final item = itemList[index];
                        if (itemList.length - 1 == index && loadMore) {
                          notifier.loadMore();
                          return const AppLoader();
                        }
                        return InkWell(
                          onTap: () {
                            final notifier =
                                ref.read(enquiryNotifierProvider.notifier);
                            if (AppUtils.isAccessAllowed(
                              moduleType: EntityType.enquiryModule,
                              accessType: EntityType.update,
                              ref: ref,
                            )) {
                              notifier.setEnquiryItem(data: item);
                              notifier.getEnquiryItemList(
                                enquiryId: item.enquiryId,
                              );

                              context
                                  .pushRoute(
                                    AddEnquiryRoute(
                                      isUpdate: true,
                                      enquiryId: item.enquiryId,
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
                          child: EnquiryTile(
                            enquiryItem: item,
                            enquiryDate: item.enquiryDate,
                          ).pad(bottom: 20),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ).padHor(15),
      ),
    );
  }
}
