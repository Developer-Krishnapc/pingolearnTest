import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/load_error_state.dart';
import '../../domain/model/print_model.dart';
import '../design/components/sample_pages_app_bar.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/input_field_widget.dart';
import '../theme/config/app_color.dart';
import 'components/label_widget.dart';
import 'provider/printer_notifier.dart';

@RoutePage()
class PrinterPage extends ConsumerStatefulWidget {
  const PrinterPage({
    super.key,
    required this.moduleType,
    this.id,
    this.hangerId,
  });
  final String moduleType;
  final int? id;
  final int? hangerId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrinterPageState();
}

class _PrinterPageState extends ConsumerState<PrinterPage> {
  ProviderSubscription? _printerSubscription;
  @override
  void initState() {
    _printerSubscription = ref.listenManual<LoadErrorState<PrintModel>>(
        printerNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(printerNotifierProvider.notifier).loadPreviousPrinterIP();
    });
    super.initState();
  }

  @override
  void dispose() {
    _printerSubscription?.close();
    super.dispose();
  }

//
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(printerNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final loadingState = ref.watch(
            printerNotifierProvider.select((value) => value.loading),
          );
          final stateData = ref.watch(
            printerNotifierProvider.select((value) => value.data),
          );

          final totalItemLength =
              stateData.hangerList.length + stateData.designList.length;

          return ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: double.maxFinite,
            ),
            child: CustomFilledButton(
              isLoading: loadingState,
              title: 'Print',
              onTap: () async {
                if (notifier.formKey.currentState?.validate() == true) {
                  final data = await notifier.sendPrintRequest();
                  if (data == totalItemLength) {
                    // ignore: use_build_context_synchronously
                    AppUtils.flushBar(
                      context,
                      'All Items printed successfully',
                    );
                    // ignore: use_build_context_synchronously
                    context.popRoute();
                  }
                }
              },
            ),
          ).pad(bottom: 20, left: 20, right: 20);
        },
      ),
      body: SafeArea(
        child: Form(
          key: notifier.formKey,
          child: CustomScrollView(
            slivers: [
              const SliverGap(20),
              const SliverToBoxAdapter(
                child: SamplePageAppBar(title: 'Printer Page'),
              ),
              const SliverGap(20),
              SliverToBoxAdapter(
                child: InputFieldWidget(
                  inputLabel: 'Enter your IP address of the printer machine',
                  mandatory: true,
                  formField: CustomFormField.name(
                    hintText: 'Ex. 192.168.68.102',
                    controller: notifier.ipCtrl,
                  ),
                ),
              ),
              const SliverGap(20),
              SliverToBoxAdapter(
                child: InputFieldWidget(
                  inputLabel: 'Enter the printer name',
                  mandatory: true,
                  formField: CustomFormField.name(
                    hintText: 'Ex. ZDesigner ZD220-203dpi ZPL',
                    controller: notifier.nameCtrl,
                  ),
                ),
              ),
              const SliverGap(20),
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(
                      printerNotifierProvider.select((value) => value.data),
                    );
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item Type:',
                                style: AppTextTheme.label14.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(10),
                              Text(
                                'Total Items:',
                                style: AppTextTheme.label14.copyWith(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.moduleType,
                                style: AppTextTheme.label14.copyWith(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(10),
                              Text(
                                state.totalItems.toString(),
                                style: AppTextTheme.label14.copyWith(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SliverGap(10),
              SliverToBoxAdapter(
                child: Text(
                  'Item List :',
                  style: AppTextTheme.label14.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SliverGap(15),
              LabelGridWidget(
                moduleType: widget.moduleType,
                id: widget.id,
                hangerId: widget.hangerId,
              ),
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
