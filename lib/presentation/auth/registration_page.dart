import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/extension/context.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../../domain/model/load_error_state.dart';
import '../routes/app_router.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/input_field_widget.dart';
import '../shared/gen/assets.gen.dart';
import '../shared/model/user_state.dart';
import '../theme/config/app_color.dart';
import 'providers/login_notifier.dart';
import 'providers/registration_notifier.dart';

@RoutePage()
class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<RegistrationPage> {
  ProviderSubscription? _registrationSubscription;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _registrationSubscription = ref.listenManual<LoadErrorState<void>>(
          registrationNotifierProvider, (previous, next) {
        if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
          AppUtils.flushBar(context, next.error, isSuccessPopup: false);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _registrationSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(registrationNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      body: Column(
        children: [
          const Gap(60),
          Align(
            child: SizedBox(
              width: context.width,
              child: Text(
                'e-shop',
                style: AppTextTheme.semiBold20.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: notifier.formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputFieldWidget(
                        inputLabel: 'Name',
                        mandatory: true,
                        formField:
                            CustomFormField.name(controller: notifier.nameCtrl),
                      ),
                      const Gap(15),
                      InputFieldWidget(
                        inputLabel: 'Email',
                        mandatory: true,
                        formField: CustomFormField.email(
                            controller: notifier.emailCtrl),
                      ),
                      const Gap(15),
                      InputFieldWidget(
                        inputLabel: 'Password',
                        mandatory: true,
                        passwordCtrl: notifier.passCtrl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final loadingState = ref.watch(
                registrationNotifierProvider.select((value) => value.loading),
              );
              return SizedBox(
                width: context.width,
                child: CustomFilledButton(
                  title: 'Signup',
                  isLoading: loadingState,
                  onTap: () {
                    notifier.createUser();
                  },
                ),
              );
            },
          ),
          const Gap(10),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Already have an account? ',
                    style: AppTextTheme.semiBold14),
                TextSpan(
                    text: 'Login',
                    style: AppTextTheme.semiBold16
                        .copyWith(color: AppColor.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.replaceRoute(LoginRoute());
                      })
              ])),
          const Gap(50),
        ],
      ).padHor(15),
    );
  }
}
