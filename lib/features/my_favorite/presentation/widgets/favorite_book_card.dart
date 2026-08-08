import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoriteBookCard extends StatefulWidget {
  const FavoriteBookCard({
    super.key,
    required this.book,
    required this.onRemovePressed,
    this.onTap,
  });

  final BookModel book;
  final Future<bool> Function() onRemovePressed;
  final VoidCallback? onTap;

  @override
  State<FavoriteBookCard> createState() => _FavoriteBookCardState();
}

class _FavoriteBookCardState extends State<FavoriteBookCard> {
  bool _isFavorite = true;

  Future<void> _removeFavorite() async {
    if (!_isFavorite) return;

    setState(() => _isFavorite = false);
    await Future<void>.delayed(const Duration(milliseconds: 250));

    try {
      final removed = await widget.onRemovePressed();
      if (!removed && mounted) {
        setState(() => _isFavorite = true);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isFavorite = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.pagePadding),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: widget.book.thumbnailUrl.isEmpty
                        ? const ColoredBox(
                            color: AppColors.grey100,
                            child: Icon(Icons.menu_book_rounded),
                          )
                        : Image.network(
                            widget.book.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const ColoredBox(
                                color: AppColors.grey100,
                                child: Icon(Icons.menu_book_rounded),
                              );
                            },
                          ),
                  ),
                ),
                const Gap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.book.title,
                        style: AppTextStyles.bodyLargeMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(AppSpacing.xs),
                      Text(
                        '\$${widget.book.price.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmallBold.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _removeFavorite,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: _isFavorite
                        ? SvgPicture.asset(
                            AppAssets.favIconSvg,
                            key: const ValueKey<bool>(true),
                            width: 24,
                            height: 24,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            key: ValueKey<bool>(false),
                            color: AppColors.primary600,
                            size: 24,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
