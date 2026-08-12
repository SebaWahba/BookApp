import 'package:flutter/material.dart';

import '../../../../../config/themes/app_colors.dart';
import '../../../../../config/themes/app_text_styles.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../data/models/author_model.dart';
import '../widgets/author_products_grid.dart';
import '../widgets/author_profile_header.dart';

class AuthorDetailScreen extends StatelessWidget {
  final AuthorModel author;

  const AuthorDetailScreen({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900, size: 22),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Authors',
          style: AppTextStyles.h5,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Author Profile Header Widget (Avatar, Role, Name, Rating)
              AuthorProfileHeader(author: author),
              const SizedBox(height: AppSpacing.xl),

              // "About" Section Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About',
                  style: AppTextStyles.h6,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // "About" Bio Paragraph
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  author.about.isNotEmpty
                      ? author.about
                      : 'No biography available for this author.',
                  style: AppTextStyles.bodyMediumRegular.copyWith(
                    color: AppColors.grey600,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // "Products" Section Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Products',
                  style: AppTextStyles.h6,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Author Products Grid Widget (Async Firestore query + Empty State)
              AuthorProductsGrid(authorId: author.id),
            ],
          ),
        ),
      ),
    );
  }
}
