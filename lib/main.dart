import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // 1. أضيفي الاستيراد ده
import 'package:bookapp/core/services/notification_service.dart'; // استيراد خدمة الإشعارات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    // تهيئة الإشعارات المحلية عند بدء التطبيق
    await NotificationService.init();

    // 2. طلب إذن الإشعارات لأندرويد 13 و 14
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(const ProviderScope(child: BookApp()));
}