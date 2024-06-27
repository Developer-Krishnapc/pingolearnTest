import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/extension/context.dart';
import '../../core/extension/widget.dart';
import '../../core/utils/app_utils.dart';
import '../routes/app_router.dart';
import '../shared/components/app_text_theme.dart';
import '../shared/components/custom_filled_button.dart';
import '../shared/components/custom_form_field.dart';
import '../shared/components/input_field_widget.dart';
import '../shared/gen/assets.gen.dart';
import '../shared/model/user_state.dart';
import '../theme/config/app_color.dart';
import 'providers/login_notifier.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<LoginPage> {
  ProviderSubscription? _loginSubscription;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loginSubscription = ref.listenManual<UserState<bool>>(
          loginNotifierProvider, (previous, next) {
        if (next.error != '' && ModalRoute.of(context)?.isCurrent == true) {
          AppUtils.flushBar(context, next.error, isSuccessPopup: false);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _loginSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(loginNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      body: Column(
        children: [
          const Gap(80),
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
              key: notifier.loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InputFieldWidget(
                    inputLabel: 'Email',
                    mandatory: true,
                    formField:
                        CustomFormField.email(controller: notifier.emaiCtrl),
                  ),
                  const Gap(15),
                  InputFieldWidget(
                    inputLabel: 'Password',
                    mandatory: true,
                    passwordCtrl: notifier.passwordCtrl,
                  ),
                ],
              ),
            ),
          ),
          const Gap(50),
          Consumer(
            builder: (context, ref, child) {
              final loadingState = ref.watch(
                loginNotifierProvider.select((value) => value.loading),
              );
              return SizedBox(
                width: context.width,
                child: CustomFilledButton(
                  title: 'Login',
                  isLoading: loadingState,
                  onTap: () {
                    notifier.login();
                  },
                ),
              );
            },
          ),
          const Gap(10),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: 'New Here? ', style: AppTextTheme.semiBold14),
                TextSpan(
                    text: 'Signup',
                    style: AppTextTheme.semiBold16
                        .copyWith(color: AppColor.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.replaceRoute(RegistrationRoute());
                      })
              ])),
          const Gap(80),
        ],
      ).padHor(15),
    );
  }
}
