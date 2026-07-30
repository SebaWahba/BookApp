import 'package:bookapp/config/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'config/themes/app_theme.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class BookApp extends ConsumerWidget { 
  const BookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider); 

    return MaterialApp.router(
      title: 'Bazar Book App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData.dark(), 
      themeMode: themeMode, 
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
    );
  }
}