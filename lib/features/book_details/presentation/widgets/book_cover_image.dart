import 'package:flutter/material.dart';

import '../../../../config/themes/app_colors.dart';

class BookCoverImage extends StatelessWidget {
  final String coverUrl;

  const BookCoverImage({super.key, required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: coverUrl.isEmpty
            ? Container(
                width: 237,
                height: 313,
                color: AppColors.grey200,
                child: const Icon(
                  Icons.book,
                  size: 64,
                  color: AppColors.grey500,
                ),
              )
            : Image.network(
                coverUrl,
                width: 237,
                height: 313,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 237,
                  height: 313,
                  color: AppColors.grey200,
                  child: const Icon(
                    Icons.book,
                    size: 64,
                    color: AppColors.grey500,
                  ),
                ),
              ),
      ),
    );
  }
}
