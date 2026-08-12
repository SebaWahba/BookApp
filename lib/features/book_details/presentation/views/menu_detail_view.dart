import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/features/book_details/presentation/providers/menu_detail_provider.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/home/presentation/vendors/providers/vendor_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(16.h),
          // Drag Handle
          Container(
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: context.colors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(24.h),
          Flexible(
            child: bookDetailsAsync.when(
              data: (bookData) {
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
                final displayBook = BookModel(
                  id: bookData.id.isNotEmpty
                      ? bookData.id
                      : widget.bookModel.id,
                  title: title,
                  authors: bookData.authors.isNotEmpty
                      ? bookData.authors
                      : widget.bookModel.authors,
                  description: description,
                  thumbnailUrl: coverUrl,
                  rating: bookData.rating > 0
                      ? bookData.rating
                      : widget.bookModel.rating,
                  price: bookData.price > 0
                      ? bookData.price
                      : widget.bookModel.price,
                );

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppLayoutWidths.maxContentWidth,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BookCoverImage(coverUrl: coverUrl),
                          const Gap(AppSpacing.sm),
                          BookHeaderSection(book: displayBook),
                          Gap(8.h),
                          if (displayVendor != null) ...[
                            BookVendorLogo(vendor: displayVendor),
                            const Gap(AppSpacing.sm),
                          ],

                          Text(
                            description,
                            style: context.type.bodyMediumRegular.copyWith(
                              color: context.colors.body,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(24.h),
                          BookReviewSection(
                            rating: displayBook.rating > 0
                                ? displayBook.rating
                                : 4.5,
                          ),
                          Gap(32.h),
                          Builder(
                            builder: (context) {
                              final unitPrice = displayBook.price > 0
                                  ? displayBook.price
                                  : 39.99;
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
                          Gap(24.h + MediaQuery.paddingOf(context).bottom),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => Padding(
                padding: EdgeInsets.all(48.r),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: EdgeInsets.all(48.r),
                child: Center(
                  child: Text(
                    '${l10n.errorLoadingBook}$err',
                    style: context.type.bodyMediumRegular.copyWith(color: context.colors.body),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
