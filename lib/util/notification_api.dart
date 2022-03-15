import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi{
  static final _notifications = FlutterLocalNotificationsPlugin();
  // static final onNotifications = BehaviorSubject<String>();

  static Future notificationDetails() async{
    // final styleInformation = BigPictureStyleInformation(
    //
    // );

    return NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_id1",
        "channel_name",
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async{
    final android = AndroidInitializationSettings('@drawable/app_icon');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async{
        print("______payload: $payload");
      }
    );
    if(initScheduled){

    }
  }

  static Future showNotification({int id = 0, String title, String body, String payload}) async =>
      _notifications.show(id, title, body, await notificationDetails(), payload: payload);

  static void showScheduledNotification(){

  }

}