import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/features/book_details/presentation/providers/menu_detail_provider.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/home/domain/entities/vendor_entity.dart';
import 'package:bookapp/features/home/presentation/vendors/providers/vendor_providers.dart';
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

  Future<void> _addToCart(BuildContext context, BookModel book, int qty) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          content: Text('Please login first!', style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.white)),
        ),
      );
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(book.id);

      await cartRef.set({
        'id': book.id,
        'title': book.title,
        'price': book.price,
        'thumbnailUrl': book.thumbnailUrl,
        'quantity': qty,
        'addedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary500,
            content: Text('Added to Cart!', style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.white)),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View Cart',
              textColor: AppColors.yellow,
              onPressed: () {
                context.push(AppRoutes.cart);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Error: $e', style: AppTextStyles.bodyMediumMedium.copyWith(color: AppColors.white)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookDetailsAsync = ref.watch(bookDetailsProvider(widget.bookModel.id));
    final vendorsAsync = ref.watch(vendorsListProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Book Details', style: AppTextStyles.h4.copyWith(color: AppColors.grey900)),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        actions: [
          // زرار الجرس مفعل كليكابل وينقل لصفحة الإشعارات
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.grey900),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.grey900),
            onPressed: () => context.push(AppRoutes.cart),
          ),
        ],
      ),
      body: bookDetailsAsync.when(
        data: (bookData) {
          VendorEntity? displayVendor = widget.vendorEntity;
          if (displayVendor == null &&
              vendorsAsync.hasValue &&
              vendorsAsync.value != null &&
              vendorsAsync.value!.isNotEmpty) {
            final vendors = vendorsAsync.value!;
            final index = widget.bookModel.id.hashCode.abs() % vendors.length;
            displayVendor = vendors[index];
          }

          final title = bookData.title.isNotEmpty ? bookData.title : widget.bookModel.title;
          final description = bookData.description.isNotEmpty ? bookData.description : widget.bookModel.description;
          final coverUrl = bookData.thumbnailUrl.isNotEmpty ? bookData.thumbnailUrl : widget.bookModel.thumbnailUrl;
          final displayBook = BookModel(
            id: bookData.id.isNotEmpty ? bookData.id : widget.bookModel.id,
            title: title,
            authors: bookData.authors.isNotEmpty ? bookData.authors : widget.bookModel.authors,
            description: description,
            thumbnailUrl: coverUrl,
            rating: bookData.rating > 0 ? bookData.rating : widget.bookModel.rating,
            price: bookData.price > 0 ? bookData.price : widget.bookModel.price,
          );

          final unitPrice = displayBook.price > 0 ? displayBook.price : 39.99;
          final totalPrice = (unitPrice * quantity).toStringAsFixed(2);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: BookCoverImage(coverUrl: coverUrl)),
                const Gap(AppSpacing.md),
                BookHeaderSection(book: displayBook),
                const Gap(AppSpacing.sm),
                if (displayVendor != null) ...[
                  BookVendorLogo(vendor: displayVendor),
                  const Gap(AppSpacing.sm),
                ],
                Text(
                  description,
                  style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey600, height: 1.5),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(AppSpacing.lg),
                BookReviewSection(
                  rating: displayBook.rating > 0 ? displayBook.rating : 4.5,
                ),
                const Gap(AppSpacing.xl),
                BookActionSection(
                  quantity: quantity,
                  price: "\$$totalPrice",
                  onIncrement: () => setState(() => quantity++),
                  onDecrement: () {
                    if (quantity > 1) {
                      setState(() => quantity--);
                    }
                  },
                  onAddToCart: () => _addToCart(context, displayBook, quantity),
                ),
                const Gap(AppSpacing.xxl),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary500),
        ),
        error: (err, stack) => Center(
          child: Text(
            '${l10n.errorLoadingBook}$err',
            style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.red),
          ),
        ),
      ),
    );
  }
}