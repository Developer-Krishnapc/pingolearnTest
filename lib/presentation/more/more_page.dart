import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extension/widget.dart';
import '../shared/providers/app_content.dart';
import '../theme/config/app_color.dart';

@RoutePage()
class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appContent =
        ref.read(appContentProvider.select((value) => value.socialMedia));
    return Scaffold(
      backgroundColor: AppColor.whiteBackground,
      bottomNavigationBar: const Text(
        'Dev V: 1.0.14',
        textAlign: TextAlign.center,
      ).pad(bottom: 40),
      body: const Text('More page'),
    );
  }
}
