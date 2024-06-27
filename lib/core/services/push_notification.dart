import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/notification_repo_impl.dart';
import 'notification_manager.dart';

final pushNotificationProvider = Provider<PushNotification>((ref) {
  return PushNotification(ref);
});

class PushNotification {
  PushNotification(this._ref) {
    _init();
  }
  final Ref _ref;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _init() async {
    final repo = _ref.read(notificationRepoProvider);
    await _firebaseMessaging.requestPermission();
    repo.onForegroundPushNotification.listen(_showNotification);
    repo.onBackgroundPushNotification.listen(_showNotification);
    FirebaseMessaging.instance.subscribeToTopic('SIGNFORMS');
  }

  void _showNotification(RemoteMessage message) {
    _ref.read(notificationManagerProvider);
    _ref.read(notificationManagerProvider).show(message);
  }

  Future<bool> isPermissionGranted() async {
    final status = await _firebaseMessaging.requestPermission();
    return status.authorizationStatus == AuthorizationStatus.authorized;
  }
}
