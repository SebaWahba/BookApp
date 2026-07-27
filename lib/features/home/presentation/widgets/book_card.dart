import 'package:bookapp/features/book_details/presentation/views/menu_detail_view.dart';
import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../books/data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VendorEntity? vendor;

  const BookCard({super.key, required this.book, this.vendor});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = book.title.isNotEmpty ? book.title : l10n.unknownTitle;
    final author = book.authors.isNotEmpty
        ? book.authors.first
        : l10n.unknownAuthor;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 127,
              height: 150,
              color: AppColors.grey100,
              child: book.thumbnailUrl.isEmpty
                  ? const Icon(Icons.menu_book)
                  : Image.network(
                      book.thumbnailUrl,
                      width: 127,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.menu_book),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 127,
            child: Text(
              title,
              style: AppTextStyles.bodyMediumMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 127,
            child: Text(
              author,
              style: AppTextStyles.bodySmallRegular.copyWith(
                color: AppColors.grey500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
