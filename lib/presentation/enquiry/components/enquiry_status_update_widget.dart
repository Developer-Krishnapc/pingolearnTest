import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extension/context.dart';
import '../../../core/extension/widget.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/custom_drop_down_widget.dart';
import '../../shared/components/custom_filled_button.dart';
import '../../theme/config/app_color.dart';
import '../provider/enquiry_notifier.dart';

class EnquiryStatusUpdateWidget extends ConsumerWidget {
  const EnquiryStatusUpdateWidget({super.key, required this.uniqueId});
  final String uniqueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enquiryState = ref.watch(enquiryNotifierProvider);
    final enquiryNotifier = ref.read(enquiryNotifierProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
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
                      'Update Status',
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
              const Gap(10),
              Text('Status', style: AppTextTheme.label14),
              const Gap(8),
              CustomDropDown(
                hintText: 'Select Status',
                onChanged: (data) {
                  enquiryNotifier.updateSelectedEnquiryItemStatus(status: data);
                },
                items: enquiryState.data.statusList,
                selected: enquiryState.data.selectedStatus,
                title: (item) => item.name,
              ),
              const Gap(20),
              SizedBox(
                width: context.width,
                child: CustomFilledButton(
                  title: 'Done',
                  isLoading: enquiryState.loading,
                  onTap: () {
                    enquiryNotifier.editEnquiryItemStatus(uniqueId: uniqueId);
                    context.popRoute();
                  },
                ),
              ),
              const Gap(20),
            ],
          ).padAll(20),
        ),
      ),
    );
  }
}
