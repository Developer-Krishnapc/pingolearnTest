import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/entity_type.dart';
import '../../core/extension/log.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/hanger_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../design/components/sample_pages_app_bar.dart';
import '../shared/components/add_image_widget.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/custom_drop_down_widget.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/input_field_widget.dart';
import '../theme/config/app_color.dart';
import 'provider/hanger_notifier.dart';

@RoutePage()
class AddHangerPage extends ConsumerStatefulWidget {
  const AddHangerPage({super.key});

  @override
  ConsumerState<AddHangerPage> createState() => _AddHangerPageState();
}

class _AddHangerPageState extends ConsumerState<AddHangerPage> {
  ProviderSubscription? _hangerSubscription;

  @override
  void initState() {
    _hangerSubscription = ref.listenManual<PaginationState<HangerModel>>(
        hangerNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(hangerNotifierProvider.notifier).clearData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _hangerSubscription?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(hangerNotifierProvider.notifier);
    final imageListLenState = ref.watch(
      hangerNotifierProvider
          .select((value) => value.data.selectedImageListLength),
    );
    final imageList = ref.watch(
      hangerNotifierProvider.select((value) => value.data.selectedImageList),
    );
    final collectionList = ref.read(
      hangerNotifierProvider.select((value) => value.data.collectionList),
    );
    final selectedCollection = ref.watch(
      hangerNotifierProvider.select((value) => value.data.selectedCollection),
    );
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: notifier.formKey,
            child: Column(
              children: [
                const SamplePageAppBar(title: 'Add Hanger'),
                const Gap(20),
                AddImageWidget(
                  onUpload: notifier.addSelectedImage,
                  selectedFiles: imageList,
                  maxImages: 1,
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
                      notifier.updateSelectedCollection(collectionItem: data);
                  },
                  items: collectionList,
                  title: (item) => item.name,
                  selected: selectedCollection,
                  validator: (data) {
                    if (data == null) {
                      return 'Please select collection';
                    }
                    return null;
                  },
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Hanger Name',
                  mandatory: true,
                  formField: CustomFormField.name(
                    hintText: 'Hanger Name',
                    controller: notifier.nameCtrl,
                    maxLength: EntityType.hangerNameLen,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  mandatory: true,
                  inputLabel: 'Mill Reference Number',
                  formField: CustomFormField.name(
                    hintText: 'Mill Reference Number',
                    controller: notifier.millRefNoCtrl,
                    maxLength: EntityType.millRefNoLen,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Buyer Reference Number',
                  formField: CustomFormField.name(
                    hintText: 'Buyer Reference Number',
                    controller: notifier.buyerRefNoCtrl,
                    maxLength: EntityType.buyRefConsLen,
                    isOptional: true,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Composition',
                  formField: CustomFormField.name(
                    hintText: 'Composition',
                    controller: notifier.compositionCtrl,
                    maxLength: EntityType.compoLen,
                    isOptional: true,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Count',
                  formField: CustomFormField.name(
                    hintText: 'Count',
                    controller: notifier.countCtrl,
                    maxLength: EntityType.countLen,
                    isOptional: true,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Width',
                  formField: CustomFormField.number(
                    hintText: 'Width',
                    controller: notifier.widthCtrl,
                    maxLength: EntityType.widthLen,
                    isOptional: true,
                    suffixWidget: Text(
                      'Inch',
                      style: AppTextTheme.label14
                          .copyWith(color: AppColor.primary),
                    ).padRight(15),
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Weight',
                  formField: CustomFormField.number(
                    hintText: 'Weight',
                    controller: notifier.weightCtrl,
                    isOptional: true,
                    maxLength: EntityType.weightLen,
                    suffixWidget: Text(
                      'GSM',
                      style: AppTextTheme.label14
                          .copyWith(color: AppColor.primary),
                    ).padRight(15),
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Construction',
                  formField: CustomFormField.name(
                    hintText: 'Construction',
                    controller: notifier.constructionCtrl,
                    maxLength: EntityType.consLen,
                    isOptional: true,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Hanger Code',
                  formField: CustomFormField.name(
                    hintText: 'Hanger Code',
                    controller: notifier.codeCtrl,
                    isOptional: true,
                  ),
                ),
                const Gap(15),
                Consumer(
                  builder: (context, ref, child) {
                    final loadingState = ref.watch(
                      hangerNotifierProvider.select((value) => value.loading),
                    );

                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.maxFinite,
                      ),
                      child: CustomFilledButton(
                        isLoading: loadingState,
                        title: 'Save',
                        onTap: () async {
                          if (imageListLenState == 0) {
                            'log'.logError();
                            AppUtils.flushBar(
                              context,
                              'Please add hanger image',
                              isSuccessPopup: false,
                            );
                            return;
                          }
                          final data = await notifier.addHanger();
                          if (data) {
                            AppUtils.flushBar(
                              context,
                              'Hanger created successfully',
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                const Gap(10),
              ],
            ).padHor(15),
          ),
        ),
      ),
    );
  }
}
