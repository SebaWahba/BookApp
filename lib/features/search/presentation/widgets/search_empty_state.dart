import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:flutter/material.dart';

class SearchEmptyState extends StatelessWidget {
  final bool isInitial;

  const SearchEmptyState({super.key, this.isInitial = true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: context.colors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInitial ? Icons.search_rounded : Icons.menu_book_rounded,
              size: 48,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            isInitial ? 'Search for Books' : 'No Books Found',
            style: context.type.h5.copyWith(color: context.colors.title),
          ),
          const SizedBox(height: 8),
          Text(
            isInitial
                ? 'Type a title, author or topic\nto find your next read'
                : 'Try a different keyword\nor check your spelling',
            textAlign: TextAlign.center,
            style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
          ),
        ],
      ),
    );
  }
}
