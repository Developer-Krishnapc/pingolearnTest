import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extension/context.dart';
import '../../core/services/remote_config.dart';
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(remoteConfigProvider).init();
      await Future.delayed(const Duration(milliseconds: 200));
      await ref.read(appContentProvider.notifier).updateState();
      ref.read(routerProvider).replaceAll([const MainRoute()]);
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
        body: Container(
      height: context.height,
      width: context.width,
      color: AppColor.lightBackground,
      child: Center(
        child: Assets.icons.images.dummyNewsIcon.image(),
      ),
    ));
  }
}
