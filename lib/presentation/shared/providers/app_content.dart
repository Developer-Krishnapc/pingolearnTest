import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/flavor.dart';
import '../../../core/services/remote_config.dart';
// import '../gen/assets.gen.dart';
import '../gen/assets.gen.dart';
import '../model/app_content.dart';

part 'app_content.g.dart';

@Riverpod(keepAlive: true)
class AppContent extends _$AppContent {
  @override
  AppContentModel build() {
    return const AppContentModel();
  }

  Future<void> updateState() async {
    String data = ref.read(remoteConfigProvider).getString('app_content');
    if (data.isEmpty) {
      //TODO: change flavor specific
      final flavor = Flavor.values.firstWhere(
        (element) => element.name == const String.fromEnvironment('FLAVOR'),
      );
      switch (flavor) {
        case Flavor.development:
          data =
              await rootBundle.loadString(Assets.json.development.appContent);
          break;
        case Flavor.staging:
          data = await rootBundle.loadString(Assets.json.staging.appContent);
          break;
        case Flavor.production:
          data = await rootBundle.loadString(Assets.json.production.appContent);
          break;
      }
    }
    state = AppContentModel.fromJson(jsonDecode(data));
  }
}
