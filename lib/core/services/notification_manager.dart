// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/model/predefined.dart';
// import 'package:my_udaan_customer/core/extension/log.dart';
// import 'package:my_udaan_customer/domain/model/predefined.dart';
// import 'package:my_udaan_customer/presentation/routes/app_router.dart';
// import 'package:my_udaan_customer/presentation/shared/providers/router.dart';

// void navigate(Ref _ref, NotificationResponse details) {
//   if (details.payload == null) {
//     return;
//   }
//   final data = Predefined.fromJson(jsonDecode(details.payload!));
//   switch (data.entitySubType) {
//     case 'ASSISTANCE':
//       _ref.read(routerProvider).push(const BookingFormRoute());
//   }
// }

// final notificationManagerProvider = Provider<NotificationManager>((ref) {
//   return NotificationManager(ref);
// });

// class NotificationManager {
//   NotificationManager(this._ref) {
//     //   _setUpLocalNotification();
//   }
//   final Ref _ref;

// static FlutterLocalNotificationsPlugin localNotification =
//     FlutterLocalNotificationsPlugin();

// Future<void> _setUpLocalNotification() async {
//   await localNotification.initialize(
//     InitializationSettings(
//       android: const AndroidInitializationSettings('@mipmap/launcher_icon'),
//       iOS: DarwinInitializationSettings(
//         onDidReceiveLocalNotification: (id, title, body, payload) {
//           payload.logError();
//         },
//       ),
//     ),
//     // onDidReceiveNotificationResponse: (details) => navigate(_ref, details),
//     // onDidReceiveBackgroundNotificationResponse: (details) =>
//     //     navigate(_ref, details),
//   );

//   final platform = localNotification.resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>();

//   const channel = AndroidNotificationChannel(
//     'Coach Vikram',
//     'Coach Vikram',
//   );
//   platform?.createNotificationChannel(channel);
// }

// void show(RemoteMessage message) {
//   localNotification.show(
//     message.hashCode,
//     message.notification?.title ?? 'myUdaan',
//     message.notification?.body ?? '',
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'notification',
//         'Notification',
//         styleInformation: BigTextStyleInformation(''),
//       ),
//     ),
//     payload: jsonEncode(message.data),
//   );
// }

void navigate(NotificationResponse details) {
  if (details.payload == null) {
    return;
  }
  final data = Predefined.fromJson(jsonDecode(details.payload!));
}

void handleIOSNotification(id, title, body, payload) {}

final notificationManagerProvider = Provider<NotificationManager>((ref) {
  return NotificationManager(ref);
});

class NotificationManager {
  NotificationManager(this._ref) {
    _setUpLocalNotification();
  }
  // ignore: unused_field
  final Ref _ref;

  static FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  Future<void> _setUpLocalNotification() async {
    await localNotification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(
          onDidReceiveLocalNotification: handleIOSNotification,
        ),
      ),
      onDidReceiveNotificationResponse: navigate,
      onDidReceiveBackgroundNotificationResponse: navigate,
    );

    final platform = localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    const channel = AndroidNotificationChannel(
      'Euroside',
      'Euroside',
    );
    platform?.createNotificationChannel(channel);
  }

  void show(RemoteMessage message) {
    if (message.notification != null) {
      localNotification.show(
        message.hashCode,
        message.notification?.title ?? 'Euroside',
        message.notification?.body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'notification',
            'Notification',
            styleInformation: BigTextStyleInformation(''),
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }
}
