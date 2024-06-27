import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/user.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/input_field_widget.dart';
import '../shared/components/profile_background_widget.dart';
import '../shared/components/profile_image_edit_widget.dart';
import '../shared/model/user_state.dart';
import '../theme/config/app_color.dart';
import 'providers/user_notifier.dart';

@RoutePage()
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  ProviderSubscription? _staffSubscription;
  final _controller = ScrollController();

  @override
  void initState() {
    _staffSubscription = ref.listenManual<UserState<User>>(userNotifierProvider,
        (previous, next) {
      if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
        AppUtils.flushBar(context, next.error, isSuccessPopup: false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _staffSubscription?.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userNotifierProvider.notifier);
    final state = ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileBackgroundWidget(
                pageTitle: 'Edit Profile',
                imageWidget: ProfileImageEditWidget(
                  imageUrl: state.data.profileImage.url,
                  selectedImagePath: notifier.selectedImagePath.text,
                  onUpload: (files) {
                    if (files.isNotEmpty) {
                      notifier.updateSelectedImage(imagefilePath: files.first);
                    }
                  },
                ),
              ),
              Form(
                key: notifier.formKey,
                child: Column(
                  children: [
                    InputFieldWidget(
                      inputLabel: 'Name',
                      mandatory: true,
                      formField: CustomFormField.name(
                        hintText: 'Name',
                        controller: notifier.nameCtrl,
                        isUserName: true,
                      ),
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Mobile No',
                      mandatory: true,
                      formField:
                          CustomFormField.phone(controller: notifier.phoneCtrl),
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Email ID',
                      mandatory: true,
                      formField: CustomFormField.email(
                        hintText: 'Email ID',
                        controller: notifier.emailCtrl,
                      ),
                    ),
                    const Gap(10),
                    InputFieldWidget(
                      inputLabel: 'Password',
                      mandatory: true,
                      passwordCtrl: notifier.passCtrl,
                      isPassEmptyValidationRequired: true,
                    ),
                    const Gap(20),
                    SizedBox(
                      width: double.maxFinite,
                      child: CustomFilledButton(
                        title: 'Save',
                        isLoading: state.loading,
                        onTap: () async {
                          if (notifier.formKey.currentState?.validate() ==
                              true) {
                            final data = await notifier.updateUserData();
                            if (data) {
                              AppUtils.flushBar(
                                context,
                                'Profile Updated Successfully',
                              );

                              context.popRoute();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ).padHor(15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
