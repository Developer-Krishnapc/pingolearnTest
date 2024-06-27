import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../../data/model/hanger_dropdown_model.dart';
import '../../design/components/sample_pages_app_bar.dart';
import '../../design/providers/design_list_notifier.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/custom_drop_down_widget.dart';
import '../../shared/components/custom_filled_button.dart';
import '../../shared/components/custom_form_field.dart';
import '../../shared/components/dropdown_container_widget.dart';
import '../../shared/components/input_field_widget.dart';
import '../../shared/components/searchable_dropdown_bottomsheet.dart';
import '../../theme/config/app_color.dart';

class DesignFilterDrawer extends ConsumerWidget {
  const DesignFilterDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designListState = ref.watch(designListNotifierProvider);
    final designListNotifier = ref.read(designListNotifierProvider.notifier);
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
              Row(
                children: [
                  Text('Collection Name', style: AppTextTheme.label14),
                  Text(
                    '*',
                    style: AppTextTheme.label14.copyWith(color: AppColor.red),
                  ).padLeft(5),
                ],
              ),
              const Gap(8),
              CustomDropDown(
                hintText: 'Select Collection Name',
                onChanged: (data) {
                  if (data != null)
                    designListNotifier.updateSelectedCollection(
                      collectionItem: data,
                    );
                },
                items: designListState.data.collectionList,
                title: (item) => item.name,
                selected: designListState.data.selectedCollection,
                validator: (data) {
                  if (data == null) {
                    return 'Please select collection';
                  }
                  return null;
                },
              ),
              const Gap(8),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Hanger Name', style: AppTextTheme.label14),
                    ],
                  ),
                  const Gap(8),
                  DropdownConatinerWidget(
                    onTap: () async {
                      await designListNotifier.getHangerList();

                      // ignore: use_build_context_synchronously
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Consumer(
                            builder: (context, ref, child) {
                              final hangerList = ref.watch(
                                designListNotifierProvider.select(
                                  (value) => value.data.hangerList,
                                ),
                              );

                              final searchLoading = ref.watch(
                                designListNotifierProvider.select(
                                  (value) => value.data.dropdownSearchLoading,
                                ),
                              );

                              return DropDownSearchWidget<HangerDropdownModel>(
                                onSelect: (item) {
                                  designListNotifier.updateSelectedHanger(
                                    hangerItem: item,
                                  );
                                },
                                loading: searchLoading,
                                data: hangerList,
                                title: (item) => item.name,
                                searchCtrl: designListNotifier.hangerSearchCtrl,
                              );
                            },
                          );
                        },
                      );
                    },
                    errorString: 'Please select hanger',
                    isMandatory: false,
                    selectedValue:
                        designListState.data.selectedHanger?.name ?? '',
                  ),
                ],
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Buyer Reference Number',
                formField: CustomFormField.name(
                  hintText: 'Buyer Reference Number',
                  controller: designListNotifier.buyerRefNoCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Count',
                formField: CustomFormField.name(
                  hintText: 'Count',
                  controller: designListNotifier.countCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Composition',
                formField: CustomFormField.name(
                  hintText: 'Composition',
                  controller: designListNotifier.compositionCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Construction',
                formField: CustomFormField.name(
                  hintText: 'Construction',
                  controller: designListNotifier.constructionCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Mill Reference Number',
                formField: CustomFormField.name(
                  hintText: 'Mill Reference Number',
                  controller: designListNotifier.millRefNoCtrl,
                ),
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Width',
                formField: CustomFormField.number(
                  hintText: 'Width',
                  controller: designListNotifier.widthCtrl,
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
                  controller: designListNotifier.weightCtrl,
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
                        designListNotifier.clearFilter();

                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: CustomFilledButton(
                      title: 'Apply Now',
                      onTap: () async {
                        designListNotifier.applyFilter();

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
