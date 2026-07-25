import 'package:flutter/material.dart';
import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';

class VendorCardItem extends StatelessWidget {
  final VendorEntity vendor; //
  final VoidCallback? onTap;

  const VendorCardItem({super.key, required this.vendor, this.onTap});

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFFF7F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                vendor.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    vendor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color(0xFF222222),
                    ),
                    textAlign: TextAlign.center,
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
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
                      : const Color(0xFF111111),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
