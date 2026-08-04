import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/presentation/providers/theme_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    // تجميع الأكشنز الأصلية بتاعة الصفحة مضاف ليها زرار الثيم الثابت
    final List<Widget> defaultActions = [
      IconButton(
        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
        onPressed: () {
          ref.read(themeModeProvider.notifier).toggleTheme(!isDark);
        },
      ),
      ...?actions,
    ];

    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: showLeading,
      actions: defaultActions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}