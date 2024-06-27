import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/constants/entity_type.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../data/model/hanger_dropdown_model.dart';
import '../../domain/model/design_model.dart';
import '../../domain/model/pagination_state_model.dart';
import '../shared/components/add_image_widget.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/content_detail_widget.dart';
import '../shared/components/custom_drop_down_widget.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/dropdown_container_widget.dart';
import '../shared/components/input_field_widget.dart';
import '../shared/components/searchable_dropdown_bottomsheet.dart';
import '../theme/config/app_color.dart';
import 'components/sample_pages_app_bar.dart';
import 'providers/design_notifier.dart';

@RoutePage()
class EditDesignPage extends ConsumerStatefulWidget {
  const EditDesignPage({
    super.key,
    required this.heroTag,
    required this.id,
    this.hangerId,
  });
  final String heroTag;
  final int id;
  final int? hangerId;

  @override
  ConsumerState<EditDesignPage> createState() => _EditDesignPageState();
}

class _EditDesignPageState extends ConsumerState<EditDesignPage> {
  ProviderSubscription? _designSubscription;
  @override
  void initState() {
    _designSubscription = ref.listenManual<PaginationState<DesignModel>>(
        designNotifierProvider, (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _designSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(designNotifierProvider.notifier);
    final imageListLenState = ref.watch(
      designNotifierProvider
          .select((value) => value.data.selectedImageListLength),
    );
    final imageList = ref.watch(
      designNotifierProvider.select((value) => value.data.selectedImageList),
    );
    final hangerList = ref.read(
      designNotifierProvider.select((value) => value.data.hangerList),
    );
    final selectedHanger = ref.watch(
      designNotifierProvider.select((value) => value.data.selectedHanger),
    );
    final designId = ref.watch(
      designNotifierProvider.select((value) => value.data.selectedDesign.id),
    );
    final collectionList = ref.watch(
      designNotifierProvider.select((value) => value.data.collectionList),
    );

    final selectedCollection = ref.watch(
      designNotifierProvider.select((value) => value.data.selectedCollection),
    );
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: notifier.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SamplePageAppBar(title: 'Edit Design'),
                const Gap(20),
                AddImageWidget(
                  onUpload: notifier.addSelectedImage,
                  selectedFiles: imageList,
                  heroTag: widget.heroTag,
                  onRemove: notifier.removeDesignImage,
                ),
                const Gap(20),
                ContentDetailWidget(
                  titleName: 'Design Id',
                  description: designId.toString(),
                ),
                const Gap(12),
                Row(
                  children: [
                    Text('Collection Name', style: AppTextTheme.label14),
                    Text(
                      '*',
                      style: AppTextTheme.label14.copyWith(color: AppColor.red),
                    ).padLeft(5),
                  ],
                ),
                const Gap(5),
                CustomDropDown(
                  hintText: 'Select Collection Name',
                  onChanged: (data) {
                    if (data != null)
                      notifier.updateSelectedCollection(collectionItem: data);
                  },
                  items: collectionList,
                  title: (item) => item.name,
                  selected: selectedCollection,
                ),
                const Gap(12),
                Row(
                  children: [
                    Text('Hanger Name', style: AppTextTheme.label14),
                    Text(
                      '*',
                      style: AppTextTheme.label14.copyWith(color: AppColor.red),
                    ).padLeft(5),
                  ],
                ),
                const Gap(8),
                DropdownConatinerWidget(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Consumer(
                          builder: (context, ref, child) {
                            final hangerList = ref.watch(
                              designNotifierProvider
                                  .select((value) => value.data.hangerList),
                            );
                            final searchLoading = ref.watch(
                              designNotifierProvider.select(
                                (value) => value.data.dropdownSearchLoading,
                              ),
                            );
                            return DropDownSearchWidget<HangerDropdownModel>(
                              onSelect: (item) {
                                notifier.updateSelectedHanger(hangerItem: item);
                              },
                              loading: searchLoading,
                              data: hangerList,
                              title: (item) => item.name,
                              searchCtrl: notifier.hangerSearchCtrl,
                            );
                          },
                        );
                      },
                    ).whenComplete(() => notifier.hangerSearchCtrl.clear());
                  },
                  selectedValue: selectedHanger?.name ?? '',
                  errorString: 'Please select hanger',
                  isMandatory: true,
                ),

                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Mill Reference Number',
                  mandatory: true,
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
                  mandatory: true,
                  formField: CustomFormField.name(
                    hintText: 'Count',
                    controller: notifier.countCtrl,
                    isOptional: true,
                    maxLength: EntityType.countLen,
                  ),
                ),
                const Gap(10),
                InputFieldWidget(
                  inputLabel: 'Width',
                  formField: CustomFormField.number(
                    controller: notifier.widthCtrl,
                    maxLength: EntityType.widthLen,
                    isOptional: true,
                    hintText: 'Width',
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
                    controller: notifier.weightCtrl,
                    maxLength: EntityType.weightLen,
                    isOptional: true,
                    hintText: 'Weight',
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
                // const Gap(10),
                // InputFieldWidget(
                //   inputLabel: 'Design Id',
                //   mandatory: true,
                //   formField: CustomFormField.name(
                //     hintText: 'Sample Id',
                //   ),
                // ),
                // const Gap(10),
                // InputFieldWidget(
                //   inputLabel: 'Hange Code',
                //   mandatory: true,
                //   formField: CustomFormField.name(
                //     hintText: 'Hange Code',
                //   ),
                // ),
                const Gap(15),
                Consumer(
                  builder: (context, ref, child) {
                    final loadingState = ref.watch(
                      designNotifierProvider.select((value) => value.loading),
                    );
                    return ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.maxFinite,
                      ),
                      child: CustomFilledButton(
                        title: 'Save',
                        isLoading: loadingState,
                        onTap: () async {
                          if (selectedHanger == null) {
                            AppUtils.flushBar(
                              context,
                              'Please select hanger',
                              isSuccessPopup: false,
                            );
                            return;
                          }
                          final data = await notifier.updateDesign(
                            id: widget.id,
                            hangerId: widget.hangerId,
                          );
                          if (data == true) {
                            AppUtils.flushBar(
                              context,
                              'Design updated successfully',
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
