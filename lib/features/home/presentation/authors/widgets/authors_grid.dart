import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/features/home/domain/entities/author_entity.dart';
import 'author_card_item.dart';

class AuthorsGrid extends StatelessWidget {
  final List<AuthorEntity> authors;

  const AuthorsGrid({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth ~/ 130.w).clamp(2, 5);

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          itemCount: authors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            return AuthorCardItem(author: authors[index], onTap: () {});
          },
        );
      },
    );
  }
}
