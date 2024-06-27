import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/widget.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/custom_drop_down_widget.dart';
import '../../shared/components/custom_filled_button.dart';
import '../../shared/components/custom_form_field.dart';
import '../../shared/components/input_field_widget.dart';
import '../../theme/config/app_color.dart';
import '../provider/enquiry_list_notifier.dart';

class EnquiryFilter extends ConsumerWidget {
  const EnquiryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(enquiryListNotifierProvider.notifier);
    final enquiryState =
        ref.watch(enquiryListNotifierProvider.select((value) => value.data));

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 600,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Enquiry Filters',
                      style: AppTextTheme.label16.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.popRoute();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Gap(15),
              InputFieldWidget(
                inputLabel: 'Location',
                formField: CustomFormField.name(
                  hintText: 'Location',
                  controller: notifier.locationCtrl,
                ),
              ),
              const Gap(10),
              Text('Status', style: AppTextTheme.label14),
              const Gap(8),
              CustomDropDown(
                hintText: 'Select Status',
                onChanged: (data) {
                  notifier.updateSelectedStatus(status: data);
                },
                items: enquiryState.statusList,
                title: (item) => item.name,
                selected: enquiryState.selectedStatus,
              ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: CustomFilledButton(
                      title: 'Clear',
                      onTap: () {
                        notifier.clearFilter();
                        context.popRoute();
                      },
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: CustomFilledButton(
                      title: 'Apply',
                      onTap: () {
                        notifier.applyFilter();
                        context.popRoute();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ).padAll(20),
        ),
      ),
    );
  }
}
