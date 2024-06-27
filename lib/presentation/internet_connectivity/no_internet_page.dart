import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/components/app_text_theme.dart';
import '../shared/gen/assets.gen.dart';

@RoutePage()
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NoInternetWidget(),
    );
  }
}

class NoInternetWidget extends ConsumerWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.lottie.noInternetLottie.lottie(repeat: true),
          Text(
            'Oops No Internet Connection',
            style: AppTextTheme.semiBold16,
          ),
        ],
      ),
    );
  }
}
