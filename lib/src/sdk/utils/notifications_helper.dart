import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../config.dart';

class NotificationsHelper {
  NotificationDetails _platformChannelSpecifics;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  NotificationsHelper._privateConstructor();

  static final NotificationsHelper _instance = NotificationsHelper._privateConstructor();

  static NotificationsHelper get instance {
    return _instance;
  }

  init() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Config.NOTIFICATION_CHANNEL_ID,
      Config.NOTIFICATION_CHANNEL_NAME,
      Config.NOTIFICATION_CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    _platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  }

  void show(String title, String message, {String payload}) async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      message,
      _platformChannelSpecifics,
      payload: payload,
    );
  }

  void schedule(
    String title,
    String message,
    DateTime dateTime, {
    int id,
    String payload,
  }) async {
    await _flutterLocalNotificationsPlugin.schedule(
      id ?? DateTime.now().millisecond,
      title,
      message,
      dateTime,
      _platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  void cancelAll() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }

  void cancel(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('Notification Selected. Payload: ' + payload);
    }
    // await Navigator.push(
    //   context,
    //   new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    // );
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page

    print("Local Notification Received: $id|$title|$body|$payload");
  }

  Future<NotificationAppLaunchDetails> getNotificationAppLaunchDetail() {
    return _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }
}
