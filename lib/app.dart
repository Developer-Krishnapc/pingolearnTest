import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/internet_connectivity/internet_scaffold_wrapper.dart';
import 'presentation/shared/providers/router.dart';
import 'presentation/theme/config/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return InternetStateWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router.config(),
        title: 'Duratex',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
      ),
    );
  }
}
