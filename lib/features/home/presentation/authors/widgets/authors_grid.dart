import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/features/home/domain/entities/author_entity.dart';
import 'package:bookapp/features/home/data/models/author_model.dart';
import 'author_card_item.dart';
import 'package:bookapp/features/home/presentation/authors/views/author_detail_screen.dart';

class AuthorsGrid extends StatelessWidget {
  final List<AuthorEntity> authors;

  const AuthorsGrid({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth ~/ 130).clamp(2, 5);

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          itemCount: authors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            // Lowered from 0.72 to 0.62 to give each cell more vertical
            // room — fixes bottom overflow on name/jobTitle text on tablet.
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) {
            return AuthorCardItem(
              author: authors[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AuthorDetailScreen(
                    author: authors[index] as AuthorModel,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}