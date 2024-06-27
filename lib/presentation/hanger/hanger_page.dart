import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/entity_type.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/hanger_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../home/components/hanger_filter_widget.dart';
import '../home/components/home_app_bar.dart';
import '../printer/provider/printer_notifier.dart';
import '../routes/app_router.dart';
import '../shared/components/common_refresh_indicator.dart';
import '../shared/components/icon_button.dart';
import '../shared/components/search_widget.dart';
import '../shared/gen/assets.gen.dart';
import '../theme/config/app_color.dart';
import 'components/hanger_list_widget.dart';
import 'provider/hanger_list_notifier.dart';

@RoutePage()
class HangerPage extends ConsumerStatefulWidget {
  const HangerPage({super.key});

  @override
  ConsumerState<HangerPage> createState() => _HangerPageState();
}

class _HangerPageState extends ConsumerState<HangerPage> {
  ProviderSubscription? _hangerSubscription;
  final _controller = ScrollController();

  @override
  void initState() {
    _hangerSubscription = ref.listenManual<PaginationState<HangerListModel>>(
        hangerListNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final hangerState = ref.read(
        hangerListNotifierProvider.select((value) => value.data.hangerItemList),
      );
      if (hangerState.isEmpty) {
        final notifier = ref.read(hangerListNotifierProvider.notifier);
        notifier.reset();
        notifier.getHangerList();
      }
    });
  }

  @override
  void dispose() {
    _hangerSubscription?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final notifier = ref.read(hangerListNotifierProvider.notifier);
    final isFilterApplied = ref.watch(
      hangerListNotifierProvider.select((value) => value.data.isFilterApplied),
    );
    final printNotifier = ref.read(printerNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      drawer: const HangerFilterDrawer(),
      floatingActionButton: (!isKeyboardOpen)
          ? FloatingActionButton(
              heroTag: 'Hanger',
              onPressed: () async {
                if (AppUtils.isAccessAllowed(
                  moduleType: EntityType.hangerModule,
                  accessType: EntityType.create,
                  ref: ref,
                )) {
                  context
                      .pushRoute(const AddHangerRoute())
                      .whenComplete(() => notifier.clearData());
                } else {
                  AppUtils.flushBar(
                    context,
                    'No access to create hanger',
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
            notifier.getHangerList();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: [
              const SliverGap(20),
              const SliverToBoxAdapter(
                child: HomeAppBar(
                  appBarTitle: 'Hanger',
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
                                        moduleType: EntityType.hangerModule,
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
                                final data = await notifier.exportHanger();
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
              ),
              const SliverGap(20),
              const HangerListWidget(),
              const SliverGap(60),
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
