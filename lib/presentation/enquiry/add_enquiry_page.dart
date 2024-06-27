// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/enquiry_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../design/components/sample_pages_app_bar.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/custom_drop_down_widget.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/input_field_widget.dart';
import '../theme/config/app_color.dart';
import 'components/add_enquiry_item_manual_widget.dart';
import 'components/enquiry_design_grid_widget.dart';
import 'components/expandable_fab.dart';
import 'provider/enquiry_list_notifier.dart';
import 'provider/enquiry_notifier.dart';

@RoutePage()
class AddEnquiryPage extends ConsumerStatefulWidget {
  const AddEnquiryPage({super.key, required this.isUpdate, this.enquiryId});
  final bool isUpdate;
  final int? enquiryId;

  @override
  ConsumerState<AddEnquiryPage> createState() => _AddEnquiryPageState();
}

class _AddEnquiryPageState extends ConsumerState<AddEnquiryPage> {
  final _scrollController = ScrollController();
  ProviderSubscription? _enquirySubscription;

  @override
  void initState() {
    _enquirySubscription = ref.listenManual<PaginationState<EnquiryModel>>(
        enquiryNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _enquirySubscription?.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    final notifer = ref.read(enquiryNotifierProvider.notifier);
    final statusList = ref.watch(
      enquiryNotifierProvider.select((value) => value.data.statusList),
    );
    final selectedStatus = ref.watch(
      enquiryNotifierProvider.select((value) => value.data.selectedStatus),
    );
    final enquiryItemList = ref.watch(
      enquiryNotifierProvider.select((value) => value.data.enquiryItemList),
    );
    final notifier = ref.read(enquiryListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final loading = ref.watch(
            enquiryNotifierProvider.select((value) => value.loading),
          );
          return CustomFilledButton(
            title: 'Submit',
            isLoading: loading,
            onTap: () async {
              if (widget.isUpdate) {
                final data =
                    await notifer.updateEnquiry(id: widget.enquiryId ?? 0);

                if (data) {
                  AppUtils.flushBar(context, 'Enquiry updated successfully');
                  context.popRoute();
                }
              } else {
                if (enquiryItemList.isEmpty) {
                  AppUtils.flushBar(
                    context,
                    'Add atleast 1 Enquiry item',
                    isSuccessPopup: false,
                  );
                  return;
                }
                final data = await notifer.addEnquiry();
                if (data == true) {
                  AppUtils.flushBar(context, 'Enquiry added successfully');
                  context.popRoute();
                }
              }
            },
          ).pad(bottom: 20, left: 20, right: 20);
        },
      ),
      floatingActionButton: (!isKeyboardOpen)
          ? ExpandableFabWidget(
              actionList: [
                () {
                  scanQRAction();
                },
                () {
                  showManualAddBottomSheet();
                },
              ],
            )
          : null,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: SamplePageAppBar(
                title: (widget.isUpdate) ? 'Update Enquiry' : 'Add Enquiry',
                actionWidget: (widget.isUpdate)
                    ? PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: const Align(
                          child: Icon(
                            Icons.more_vert,
                            color: AppColor.black,
                            size: 25,
                          ),
                        ),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: const Text('Export Excel'),
                            onTap: () async {
                              final data = await notifier.exportEnquiry(
                                enquiryId: widget.enquiryId,
                              );
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
                          PopupMenuItem(
                            child: const Text('Export PDF'),
                            onTap: () async {
                              AppUtils.showDownloadingWidget(
                                context: context,
                              );
                              final data = await ref
                                  .read(enquiryNotifierProvider.notifier)
                                  .exportEnquiryPdf(
                                    enquiryId: widget.enquiryId ?? -1,
                                  );

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
                      )
                    : null,
              ),
            ),
            const SliverGap(15),
            SliverToBoxAdapter(
              child: Form(
                key: notifer.formKey,
                child: Column(
                  children: [
                    InputFieldWidget(
                      inputLabel: 'Name',
                      mandatory: true,
                      formField: CustomFormField.name(
                        hintText: 'Name',
                        controller: notifer.nameCtrl,
                      ),
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Mobile No',
                      mandatory: true,
                      formField: CustomFormField.phone(
                        controller: notifer.phoneCtrl,
                      ),
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Location',
                      mandatory: true,
                      formField: CustomFormField.name(
                        hintText: 'Location',
                        controller: notifer.locationCtrl,
                      ),
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Email Id',
                      mandatory: true,
                      formField: CustomFormField.email(
                        hintText: 'Email Id',
                        controller: notifer.emailCtrl,
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Text('Status', style: AppTextTheme.label14),
                        Text(
                          '*',
                          style: AppTextTheme.label14
                              .copyWith(color: AppColor.red),
                        ).padLeft(5),
                      ],
                    ),
                    const Gap(8),
                    CustomDropDown(
                      hintText: 'Status',
                      onChanged: (data) {
                        if (data != null)
                          notifer.updateSelectedStatus(status: data);
                      },
                      validator: (data) {
                        if (data == null) {
                          return 'Please select status';
                        }
                        return null;
                      },
                      items: statusList,
                      title: (item) => item.name,
                      selected: selectedStatus,
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Description',
                      mandatory: true,
                      formField: CustomFormField.name(
                        hintText: 'Description',
                        controller: notifer.descCtrl,
                        minLines: 5,
                        maxLine: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverGap(10),
            EnquiryDesignGridWidget(enquiryItems: enquiryItemList),
            const SliverGap(60),
          ],
        ).padAll(15),
      ),
    );
  }

  Future<void> scanQRAction() async {
    final notifer = ref.read(enquiryNotifierProvider.notifier);
    final res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(
          appBarTitle: 'Scan Design / Hanger Barcode',
        ),
      ),
    );
    if (res == null || res == '-1') {
      return;
    }
    final qrResult = AppUtils.validateQROutput(data: res);
    if (qrResult != null) {
      final data = await notifer.onScan(
        moduleType: qrResult.moduleType,
        id: qrResult.id,
      );
      await Future.delayed(const Duration(milliseconds: 200));
      if (data != null && data.isNotEmpty) {
        // ignore: use_build_context_synchronously
        AppUtils.flushBar(context, data, isSuccessPopup: false);
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      // ignore: use_build_context_synchronously
      AppUtils.flushBar(
        context,
        'Invalid QR',
        isSuccessPopup: false,
      );
    }
  }

  void showManualAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final notifer = ref.read(enquiryNotifierProvider.notifier);
        return ManualEnquiryAddWidget(
          addEnquiryItemCallBack: (int id, String moduleType) async {
            final data = await notifer.onScan(
              moduleType: moduleType,
              id: id,
            );
            await Future.delayed(const Duration(milliseconds: 200));
            if (data != null && data.isNotEmpty) {
              // ignore: use_build_context_synchronously
              AppUtils.flushBar(context, data, isSuccessPopup: false);
              return;
            }
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
        );
      },
    );
  }
}
