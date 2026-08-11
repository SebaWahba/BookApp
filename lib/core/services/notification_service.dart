import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // إعدادات أندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات آيفون (iOS)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // دمج الإعدادات للمنصتين
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // إشعار الترحيب (عند تسجيل الدخول أو التسجيل)
  static Future<void> showWelcomeNotification(String userName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'welcome_channel_id',
          'Welcome Notifications',
          channelDescription: 'Notifications shown upon successful login/signup',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0,
      '🎉 Welcome to BookApp, $userName!',
      'We are thrilled to have you on board. Start exploring now!',
      platformChannelSpecifics,
    );
  }

  // 1. إشعار أن الأوردر في طريقه‌ (On the way)
  static Future<void> showOnTheWayNotification(String bookTitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'order_status_channel',
          'Order Status Notifications',
          channelDescription: 'Notifications for order updates',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      1,
      '🚚 Order On The Way!',
      'Your order for "$bookTitle" is currently on its way to you.',
      platformChannelSpecifics,
    );
  }

  // 2. إشعار أن الأوردر وصل (Delivered)
  static Future<void> showDeliveredNotification(String bookTitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'order_status_channel',
          'Order Status Notifications',
          channelDescription: 'Notifications for order updates',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      2,
      '✅ Order Delivered!',
      'Your order for "$bookTitle" has been delivered successfully. Enjoy reading!',
      platformChannelSpecifics,
    );
  }

  // 3. إشعار أن الأوردر اتلغى (Cancelled)
  static Future<void> showCancelledNotification(String bookTitle) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'order_status_channel',
          'Order Status Notifications',
          channelDescription: 'Notifications for order updates',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      3,
      '❌ Order Cancelled',
      'Your order for "$bookTitle" has been cancelled successfully.',
      platformChannelSpecifics,
    );
  }
}