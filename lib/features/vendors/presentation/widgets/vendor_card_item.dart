import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../auth/presentation/providers/theme_provider.dart';

class VendorCardItem extends ConsumerWidget {
  final VendorEntity vendor;
  final VoidCallback? onTap;

  const VendorCardItem({super.key, required this.vendor, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo Box
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  vendor.imagePath,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      vendor.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: isDark ? Colors.white : const Color(0xFF222222),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Vendor Title
          Text(
            vendor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 4),

          // Rating Stars
          Row(
            children: List.generate(
              5,
                  (index) => Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.star_rounded,
                  size: 12,
                  color: index < vendor.rating
                      ? const Color(0xFFFFC107)
                      : (isDark ? Colors.white60 : const Color(0xFF111111)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}