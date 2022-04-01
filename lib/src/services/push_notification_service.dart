import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:top_rated_app/src/sdk/utils/notifications_helper.dart';

class PushNotificationService {
  PushNotificationService._privateConstructor();
  static final PushNotificationService instance = PushNotificationService._privateConstructor();

  Future initialize() async {
    if (Platform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, sound: true);
      FirebaseMessaging.instance.requestPermission(alert: true, sound: true);
    }

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification;
        if (notification != null && notification.android != null)
          NotificationsHelper.instance.show(notification.title, notification.body);
      },
    );
  }

  subscribeTopic(String topic) {
    FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  unsubscribeTopic(String topic) {
    FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  Future<String> getToken() async => await FirebaseMessaging.instance.getToken();
}
