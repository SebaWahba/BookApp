import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/constants/app_sizing.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../data/models/author_model.dart';
import '../views/author_detail_screen.dart';

class AuthorListItem extends StatelessWidget {
  final AuthorModel author;

  const AuthorListItem({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AuthorDetailScreen(author: author),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Avatar using AppSizing
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizing.authorListItemAvatar / 2),
              child: SizedBox(
                width: AppSizing.authorListItemAvatar,
                height: AppSizing.authorListItemAvatar,
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
            const SizedBox(width: AppSpacing.lg),

            // Name & Bio Snippet using AppTextStyles & AppSpacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author.name,
                    style: AppTextStyles.bodyLargeSemiBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    author.about.isNotEmpty ? author.about : author.jobTitle,
                    style: AppTextStyles.bodySmallRegular.copyWith(
                      color: AppColors.grey500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return Container(
      color: AppColors.primary100,
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.h4.copyWith(color: AppColors.primary500),
        ),
      ),
    );
  }
}
