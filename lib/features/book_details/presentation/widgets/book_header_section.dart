import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';

class BookHeaderSection extends StatefulWidget {
  final String title;

  const BookHeaderSection({super.key, required this.title});

  @override
  State<BookHeaderSection> createState() => _BookHeaderSectionState();
}

class _BookHeaderSectionState extends State<BookHeaderSection> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(widget.title, style: AppTextStyles.h4)),
        const Gap(16),
        GestureDetector(
          onTap: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(isFavorite),
              color: AppColors.primary600,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
