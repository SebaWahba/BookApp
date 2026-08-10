import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/constants/app_sizing.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../data/models/author_model.dart';

class AuthorProfileHeader extends StatelessWidget {
  final AuthorModel author;

  const AuthorProfileHeader({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Large Circular Avatar using AppSizing
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizing.authorDetailAvatar / 2),
            child: SizedBox(
              width: AppSizing.authorDetailAvatar,
              height: AppSizing.authorDetailAvatar,
              child: author.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: author.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(color: AppColors.grey200),
                      errorWidget: (_, _, _) => _buildFallbackAvatar(author.name),
                    )
                  : _buildFallbackAvatar(author.name),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Job Title Role Text using AppTextStyles
        Text(
          author.jobTitle.isNotEmpty ? author.jobTitle : 'Author',
          style: AppTextStyles.bodyMediumRegular.copyWith(
            color: AppColors.grey600,
          ),
        ),
        const SizedBox(height: 4),

        // Author Name using AppTextStyles
        Text(
          author.name,
          style: AppTextStyles.h3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),

        // Star Rating Row with Number in Brackets e.g. (4.0)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Icon(
                  index < author.rating.floor()
                      ? Icons.star
                      : (index < author.rating ? Icons.star_half : Icons.star),
                  color: index < author.rating ? Colors.amber : const Color(0xFF1E293B),
                  size: 22,
                ),
              );
            }),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '(${author.rating.toStringAsFixed(1)})',
              style: AppTextStyles.bodyMediumBold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFallbackAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return Container(
      color: AppColors.primary100,
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.h1.copyWith(color: AppColors.primary500),
        ),
      ),
    );
  }
}
