import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/theme_provider.dart';

class BooksEmptyState extends ConsumerWidget {
  const BooksEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.65,
          child: Center(
            child: Text(
              message,
              style: AppTextStyles.bodyMediumRegular.copyWith(
                color: isDark ? Colors.white70 : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}