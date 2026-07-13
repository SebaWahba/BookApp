import 'package:bookapp/features/onbaording/presentation/views/onbaording_view.dart';
import 'package:flutter/material.dart';
import 'config/themes/app_theme.dart';
import 'features/splash/presentation/views/splash_view.dart';

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bazar Book App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashView(),
      routes: {
        '/splash': (context) => const SplashView(),
        '/onboarding': (context) => const OnbaordingView()
      },
    );
  }
}