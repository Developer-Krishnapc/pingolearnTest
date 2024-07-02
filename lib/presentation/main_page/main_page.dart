// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/providers/firebase_instance_provider.dart';
import '../profile/providers/user_notifier.dart';
import '../routes/app_router.dart';
import '../shared/components/custom_dialog.dart';
import '../shared/providers/router.dart';
import '../theme/config/app_color.dart';

@RoutePage()
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    if (ref.read(firebaseAuthInstanceProvider).currentUser == null) {
      ref.read(routerProvider).replaceAll([const LoginRoute()]);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(userNotifierProvider.notifier).getUser();
    });

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: 'Are you sure you want to exit the app',
            // onPositive: () {
            //   ref.read(sharedPrefProvider).clearAll();
            //   ref.read(routerProvider).replaceAll(
            //     [const LoginRoute()],
            //   );
            // },
            onPositive: () => Navigator.of(context).pop(true),
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    ref.read(userNotifierProvider);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: AppColor.white,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: (Platform.isIOS)
              ? const EdgeInsets.only(bottom: 10)
              : EdgeInsets.zero,
          child: const AutoTabsScaffold(
            routes: [HomeRoute()],
          ),
        ),
      ),
    );
  }
}
