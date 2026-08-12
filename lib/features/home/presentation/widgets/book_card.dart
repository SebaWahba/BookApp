import 'package:bookapp/features/book_details/presentation/views/menu_detail_view.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../auth/presentation/providers/theme_provider.dart';
import '../../../books/data/models/book_model.dart';

class BookCard extends ConsumerWidget {
  final BookModel book;
  final VendorEntity? vendor;
  final double? width;

  const BookCard({
    super.key,
    required this.book,
    this.vendor,
    this.width = 127.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title = book.title.isNotEmpty ? book.title : l10n.unknownTitle;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;
    final cardWidth = width;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.90,
              child: MenuDetailView(bookModel: book, vendorEntity: vendor),
            );
          },
        );
      },
      child: SizedBox(
        width: cardWidth,
        // Was CrossAxisAlignment.start with an explicit cover height
        // computed from cardWidth (falling back to a fixed, distorted
        // 150 whenever width was null). stretch + AspectRatio makes the
        // cover size itself off whatever width it's actually given —
        // works identically whether this card has a fixed width (e.g. a
        // horizontal rail) or is filling a responsive grid cell (width:
        // null, as in the All Books grid).
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1 / 1.18,
                child: Container(
                  color: AppColors.grey100,
                  child: book.thumbnailUrl.isEmpty
                      ? const Icon(Icons.menu_book)
                      : Image.network(
                    book.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.menu_book),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMediumMedium.copyWith(
                color: isDark ? Colors.white : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${book.price.toStringAsFixed(2)}',
              style: AppTextStyles.bodySmallBold.copyWith(
                color: AppColors.primary500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}