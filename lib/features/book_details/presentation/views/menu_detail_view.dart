import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/book_details/presentation/providers/menu_detail_provider.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/vendors/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/vendors/presentation/providers/vendor_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../widgets/book_action_section.dart';
import '../widgets/book_cover_image.dart';
import '../widgets/book_header_section.dart';
import '../widgets/book_review_section.dart';
import '../widgets/book_vendor_logo.dart';

class MenuDetailView extends ConsumerStatefulWidget {
  const MenuDetailView({super.key, required this.bookModel, this.vendorEntity});
  final BookModel bookModel;
  final VendorEntity? vendorEntity;

  @override
  ConsumerState<MenuDetailView> createState() => _MenuDetailViewState();
}

class _MenuDetailViewState extends ConsumerState<MenuDetailView> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final bookDetailsAsync = ref.watch(
      bookDetailsProvider(widget.bookModel.id),
    );
    final vendorsAsync = ref.watch(vendorsListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(16),
          // Drag Handle
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(24),
          Flexible(
            child: bookDetailsAsync.when(
              data: (bookData) {
                // Determine vendor to show based on book id
                VendorEntity? displayVendor = widget.vendorEntity;
                if (displayVendor == null &&
                    vendorsAsync.hasValue &&
                    vendorsAsync.value != null &&
                    vendorsAsync.value!.isNotEmpty) {
                  final vendors = vendorsAsync.value!;
                  final index =
                      widget.bookModel.id.hashCode.abs() % vendors.length;
                  displayVendor = vendors[index];
                }

                final title = bookData.title.isNotEmpty
                    ? bookData.title
                    : widget.bookModel.title;
                final description = bookData.description.isNotEmpty
                    ? bookData.description
                    : widget.bookModel.description;
                final coverUrl = bookData.thumbnailUrl.isNotEmpty
                    ? bookData.thumbnailUrl
                    : widget.bookModel.thumbnailUrl;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookCoverImage(coverUrl: coverUrl),
                      const Gap(AppSpacing.sm),
                      BookHeaderSection(title: title),
                      const Gap(8),
                      if (displayVendor != null) ...[
                        BookVendorLogo(vendor: displayVendor),
                        const Gap(AppSpacing.sm),
                      ],

                      Text(
                        description,
                        style: AppTextStyles.bodyMediumRegular.copyWith(
                          color: AppColors.grey500,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(24),
                      BookReviewSection(
                        rating:
                            bookData.rating > 0
                                ? bookData.rating
                                : (widget.bookModel.rating > 0
                                    ? widget.bookModel.rating
                                    : 4.5),
                      ),
                      const Gap(32),
                      Builder(
                        builder: (context) {
                          final unitPrice =
                              bookData.price > 0
                                  ? bookData.price
                                  : (widget.bookModel.price > 0
                                      ? widget.bookModel.price
                                      : 39.99);
                          final totalPrice = (unitPrice * quantity)
                              .toStringAsFixed(2);
                          return BookActionSection(
                            quantity: quantity,
                            price: "\$$totalPrice",
                            onIncrement: () => setState(() => quantity++),
                            onDecrement: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          );
                        },
                      ),
                      const Gap(32), // Bottom safe area padding
                    ],
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(48.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.all(48.0),
                child: Center(child: Text('${l10n.errorLoadingBook}$err')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
