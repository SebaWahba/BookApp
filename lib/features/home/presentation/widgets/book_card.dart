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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: cardWidth,
                height: cardWidth != null ? cardWidth * 1.18 : 150,
                color: AppColors.grey100,
                child: book.thumbnailUrl.isEmpty
                    ? const Icon(Icons.menu_book)
                    : Image.network(
                  book.thumbnailUrl,
                  width: cardWidth,
                  height: cardWidth != null ? cardWidth * 1.18 : 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.menu_book),
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