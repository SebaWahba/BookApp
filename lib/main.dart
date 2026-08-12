import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bookapp/core/services/notification_service.dart'; // استيراد خدمة الإشعارات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    // تهيئة الإشعارات المحلية عند بدء التطبيق
    await NotificationService.init();
  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(const ProviderScope(child: BookApp()));
}
