import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/entity_type.dart';
import '../../../core/extension/widget.dart';
import '../../shared/components/app_text_theme.dart';
import '../../shared/components/custom_drop_down_widget.dart';
import '../../shared/components/custom_filled_button.dart';
import '../../shared/components/custom_form_field.dart';
import '../../shared/components/input_field_widget.dart';
import '../../theme/config/app_color.dart';
import '../provider/enquiry_notifier.dart';

class ManualEnquiryAddWidget extends ConsumerStatefulWidget {
  const ManualEnquiryAddWidget({
    super.key,
    required this.addEnquiryItemCallBack,
  });
  final Future<void> Function(int id, String moduleType) addEnquiryItemCallBack;

  @override
  ConsumerState<ManualEnquiryAddWidget> createState() =>
      _ManualEnquiryAddWidgetState();
}

class _ManualEnquiryAddWidgetState
    extends ConsumerState<ManualEnquiryAddWidget> {
  final dropdownItems = [EntityType.hangerModule, EntityType.designModule];
  String? selectedValue;
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(enquiryNotifierProvider.notifier).addId.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(enquiryNotifierProvider.notifier);

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
          child: Form(
            key: notifier.manualAddKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Manually',
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
                const Gap(20),
                InputFieldWidget(
                  inputLabel: 'Id',
                  formField: CustomFormField.number(
                    hintText: 'Hanger ID / Design ID',
                    controller: notifier.addId,
                  ),
                ),
                const Gap(15),
                Row(
                  children: [
                    Text('Item type', style: AppTextTheme.label14),
                    Text(
                      '*',
                      style: AppTextTheme.label14.copyWith(color: AppColor.red),
                    ).padLeft(5),
                  ],
                ),
                const Gap(8),
                CustomDropDown(
                  hintText: 'Item type',
                  onChanged: (data) {
                    if (data != null)
                      setState(() {
                        selectedValue = data;
                      });
                  },
                  items: dropdownItems,
                  title: (item) => item,
                  selected: selectedValue,
                  validator: (data) {
                    if (data == null) {
                      return 'Please select item type';
                    }
                    return null;
                  },
                ),
                const Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: CustomFilledButton(
                        isLoading: loading,
                        title: 'Add',
                        onTap: () async {
                          if (notifier.manualAddKey.currentState?.validate() ==
                              true) {
                            setState(() {
                              loading = true;
                            });
                            await widget.addEnquiryItemCallBack.call(
                              int.parse(notifier.addId.text.trim()),
                              selectedValue ?? '',
                            );
                            setState(() {
                              loading = false;
                            });
                            // ignore: use_build_context_synchronously
                            context.popRoute();
                          }
                        },
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: CustomFilledButton(
                        title: 'Cancel',
                        onTap: () {
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
      ),
    );
  }
}
