import 'package:flutter/material.dart';

import '../../../../core/theme/extensions/theme_ext.dart';

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
                color: context.colors.surfaceAlt,
                child: Icon(
                  Icons.book,
                  size: 64,
                  color: context.colors.body,
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
                  color: context.colors.surfaceAlt,
                  child: Icon(
                    Icons.book,
                    size: 64,
                    color: context.colors.body,
                  ),
                ),
              ),
      ),
    );
  }
}
