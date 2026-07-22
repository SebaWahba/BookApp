import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../../books/data/models/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final title = book.title.isNotEmpty ? book.title : 'Unknown Title';
    final author = book.authors.isNotEmpty ? book.authors.first : 'Unknown Author';

    return Column(
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
            style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.grey500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}