import 'package:flutter/material.dart';

import '../../../../core/theme/extensions/theme_ext.dart';

class AuthorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  final double width;

  const AuthorCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.role,
    this.width = 110.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  width: 90,
                  height: 90,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 90,
                color: context.colors.surfaceAlt,
                child: Center(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.type.bodySmallBold.copyWith(
                      color: context.colors.title,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: context.type.bodyLargeMedium.copyWith(
              color: context.colors.title,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: context.type.bodySmallRegular.copyWith(
              color: context.colors.body,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
