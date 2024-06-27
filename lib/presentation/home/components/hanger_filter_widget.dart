import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../design/components/sample_pages_app_bar.dart';
import '../../hanger/provider/hanger_list_notifier.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/custom_drop_down_widget.dart';
import '../../shared/components/custom_filled_button.dart';
import '../../shared/components/custom_form_field.dart';
import '../../shared/components/input_field_widget.dart';
import '../../theme/config/app_color.dart';

class HangerFilterDrawer extends ConsumerWidget {
  const HangerFilterDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hangerState = ref.watch(hangerListNotifierProvider);
    final hangerNotifier = ref.read(hangerListNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SamplePageAppBar(
                title: 'Filter Page',
                onBackPress: () {
                  Scaffold.of(context).closeDrawer();
                },
              ),
              const Gap(20),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Collection Name', style: AppTextTheme.label14),
                    ],
                  ),
                  const Gap(8),
                  CustomDropDown(
                    hintText: 'Select Collection ',
                    onChanged: (data) {
                      if (data != null) {
                        hangerNotifier.updateSelectedCollection(
                          collectionItem: data,
                        );
                      }
                    },
                    items: hangerState.data.collectionList,
                    title: (item) => item.name,
                    selected: hangerState.data.selectedCollection,
                  ),
                ],
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Buyer Reference Number',
                formField: CustomFormField.name(
                  hintText: 'Buyer Reference Number',
                  controller: hangerNotifier.buyerRefNoCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Count',
                formField: CustomFormField.name(
                  hintText: 'Count',
                  controller: hangerNotifier.countCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Composition',
                formField: CustomFormField.name(
                  hintText: 'Composition',
                  controller: hangerNotifier.compositionCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Construction',
                formField: CustomFormField.name(
                  hintText: 'Construction',
                  controller: hangerNotifier.constructionCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Mill Reference Number',
                formField: CustomFormField.name(
                  hintText: 'Mill Reference Number',
                  controller: hangerNotifier.millRefNoCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Width',
                formField: CustomFormField.number(
                  hintText: 'Width',
                  controller: hangerNotifier.widthCtrl,
                  suffixWidget: Text(
                    'Inch',
                    style:
                        AppTextTheme.label14.copyWith(color: AppColor.primary),
                  ).padRight(15),
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Weight',
                formField: CustomFormField.number(
                  hintText: 'Weight',
                  controller: hangerNotifier.weightCtrl,
                  suffixWidget: Text(
                    'GSM',
                    style:
                        AppTextTheme.label14.copyWith(color: AppColor.primary),
                  ).padRight(15),
                ),
              ),
              const Gap(25),
              Row(
                children: [
                  Expanded(
                    child: CustomFilledButton(
                      title: 'Clear',
                      onTap: () async {
                        hangerNotifier.clearFilter();

                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: CustomFilledButton(
                      title: 'Apply Now',
                      onTap: () async {
                        hangerNotifier.applyFilter();

                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ),
                ],
              ),
              const Gap(15),
            ],
          ).padHor(20),
        ),
      ),
    );
  }
}
