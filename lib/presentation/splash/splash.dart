import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/extension/context.dart';
import '../../core/providers/token_provider.dart';
import '../../core/services/notification_manager.dart';
import '../../core/services/push_notification.dart';
import '../../core/services/remote_config.dart';
import '../../core/utils/app_utils.dart';
import '../../data/repository/auth.dart';
import '../../data/repository/notification_repo_impl.dart';
import '../../data/source/local/shar_pref.dart';
import '../profile/providers/user_notifier.dart';
import '../routes/app_router.dart';
import '../shared/gen/assets.gen.dart';
import '../shared/providers/app_content.dart';
import '../shared/providers/router.dart';
import '../theme/config/app_color.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;

  Future<void> navigate() async {
    final router = ref.read(routerProvider);
    final token = await ref.read(sharedPrefProvider).getToken();
    if (token != null) {
      final result = await ref.read(authRepoProvider).refreshToken(
            token.refreshToken,
          );
      await result.fold((l) async {
        await router.replaceAll([const LoginRoute()]);
        return;
      }, (r) async {
        await ref.read(tokenNotifierProvider.notifier).updateToken(r);
        await Future.delayed(
          const Duration(
            milliseconds: 300,
          ),
        );
        final data = await ref.read(userNotifierProvider.notifier).getUser();
        if (data != null && data == 'User Deactivated') {
          final appContent = ref.read(appContentProvider);
          AppUtils.flushBar(
            context,
            'Your account is been deactivated contact admin\nAdmin No: ${appContent.adminPhone}\nAdmin Email: ${appContent.adminEmail}',
            isSuccessPopup: false,
          );
          ref.read(sharedPrefProvider).clearAll();
          router.replaceAll([const LoginRoute()]);
        } else {
          router.replaceAll([const MainRoute()]);
        }
      });
    } else {
      await router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(remoteConfigProvider).init();
      await Future.delayed(const Duration(milliseconds: 200));
      await ref.read(appContentProvider.notifier).updateState();
      ref.refresh(notificationManagerProvider);
      ref.refresh(pushNotificationProvider);

      final firebaseToken =
          await ref.read(notificationRepoProvider).getFirebaseToken();

      try {
        if (!await checkUpdate()) {
          _timer = Timer(
            const Duration(seconds: 1),
            () => navigate(),
          );
        }
      } catch (e) {
        if (e is String) {
          AppUtils.snackBar(context, 'Error', e);
        } else {
          AppUtils.snackBar(context, 'Error', 'Something went wrong');
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(appContentProvider);
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Stack(
        children: [
          Assets.icons.images.splashFabricBackground.image(
            fit: BoxFit.fitHeight,
            height: double.maxFinite,
            alignment: Alignment.bottomCenter,
          ),
          Positioned(
            top: context.heightByPercent(12),
            child: SizedBox(
              width: context.width,
              child: Align(
                child: Assets.icons.images.duratexLogo
                    .image(width: context.widthByPercent(50)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkUpdate() async {
    // await context.replaceRoute(const UpdateRoute());
    // return true;
    return false;
    try {
      if (Platform.isAndroid) {
        //Check android update
        final update = await InAppUpdate.checkForUpdate();
        if (update.updateAvailability == UpdateAvailability.updateAvailable) {
          await context.replaceRoute(const UpdateRoute());
          return true;
        }
      }
      if (Platform.isIOS) {
        final version = (await PackageInfo.fromPlatform()).version;

        final latestVersion = ref
            .read(remoteConfigProvider)
            .getString(RemoteConfigKeys.latestVersionIOS);

        final checkUpdate = ref
            .read(remoteConfigProvider)
            .getBool(RemoteConfigKeys.checkUpdate);

        if (checkUpdate && version != latestVersion) {
          //Show Alert
          // ignore: use_build_context_synchronously
          await context.replaceRoute(const UpdateRoute());
          return true;
        }

        return false;
      }
    } catch (e) {}
    return false;
  }
}
