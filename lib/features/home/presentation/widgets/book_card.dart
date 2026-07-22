import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';
import '../../../../config/themes/app_text_styles.dart';
import '../../domain/entities/book.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  // Book entity has no real price field (not returned by Google Books API).
  // Generates a varied placeholder price per book instead of one flat value,
  // deterministic from the book's id so it stays stable across rebuilds.
  String get _placeholderPrice {
    final base = book.id.hashCode.abs() % 2000;
    final price = 9.99 + (base / 100);
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final title = book.title.isNotEmpty ? book.title : 'Unknown Title';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 127,
            height: 150,
            color: AppColors.grey100,
            child: book.thumbnail != null
                ? Image.network(
              book.thumbnail!,
              width: 127,
              height: 150,
              fit: BoxFit.cover,
            )
                : null,
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
        Text(
          _placeholderPrice,
          style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.primary500),
        ),
      ],
    );
  }
}