import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/shared/gen/assets.gen.dart';
import '../../presentation/shared/providers/app_content.dart';
import '../constants/flavor.dart';

part 'remote_config.g.dart';

@Riverpod(keepAlive: true)
RemoteConfig remoteConfig(RemoteConfigRef ref) {
  return RemoteConfig(ref);
}

class RemoteConfig {
  RemoteConfig(this._ref);
  final Ref _ref;

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.ensureInitialized();
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(seconds: 70),
      ),
    );
    await _remoteConfig.setDefaults(await _defaultConfig());
    await _remoteConfig.activate();
    await Future.delayed(const Duration(seconds: 1));
    await _remoteConfig.fetchAndActivate();
    _ref.refresh(appContentProvider.notifier).updateState();
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  Future<Map<String, dynamic>> _defaultConfig() async {
    final flavor = Flavor.values.firstWhere(
      (element) => element.name == const String.fromEnvironment('FLAVOR'),
    );
    return switch (flavor) {
      Flavor.development => {
          RemoteConfigKeys.appContent:
              await rootBundle.loadString(Assets.json.development.appContent),
        },
      Flavor.staging => {
          RemoteConfigKeys.appContent:
              await rootBundle.loadString(Assets.json.staging.appContent),
        },
      Flavor.production => {
          RemoteConfigKeys.appContent:
              await rootBundle.loadString(Assets.json.production.appContent),
        },
    };
  }
}

class RemoteConfigKeys {
  static const appContent = 'app_content';
  static const latestVersionIOS = 'latestIOSVersion';
  static const checkUpdate = 'checkUpdate';
}
