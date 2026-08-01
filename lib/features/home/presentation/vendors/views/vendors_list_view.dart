import 'package:bookapp/features/home/presentation/vendors/providers/vendor_providers.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';

import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import '../widgets/vendor_card_item.dart';
import '../widgets/vendors_error_state.dart';

class VendorsListView extends ConsumerStatefulWidget {
  const VendorsListView({super.key});

  @override
  ConsumerState<VendorsListView> createState() => _VendorsListViewState();
}

class _VendorsListViewState extends ConsumerState<VendorsListView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<String> categories = [
      l10n.all,
      l10n.books,
      l10n.poems,
      l10n.specialForYou,
      l10n.stationery,
    ];

    final selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);
    final vendorsAsync = ref.watch(vendorsListProvider);

    final isTablet =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 700.0 : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.vendors,
          style: AppTextStyles.h4.copyWith(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ourVendors,
                        style: AppTextStyles.bodySmallRegular.copyWith(
                          color: AppColors.vendorSubtleText,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        l10n.vendors,
                        style: AppTextStyles.h5.copyWith(
                          color: AppColors.vendorAccent,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                SizedBox(
                  height: 38.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedCategoryIndex;
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(selectedCategoryIndexProvider.notifier)
                              .selectCategory(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                categories[index],
                                style:
                                    (isSelected
                                            ? AppTextStyles.bodyMediumBold
                                            : AppTextStyles.bodyMediumMedium)
                                        .copyWith(
                                  color: isSelected
                                      ? AppColors.vendorTitleText
                                      : AppColors.vendorSubtleText,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              if (isSelected)
                                Container(
                                  height: 2.h,
                                  width: 18.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.vendorTitleText,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),

                Expanded(
                  child: vendorsAsync.when(
                    data: (vendors) {
                      final selectedCategory =
                      categories[selectedCategoryIndex];
                      final filteredVendors = selectedCategory == l10n.all
                          ? vendors
                          : vendors
                          .where(
                            (v) =>
                        v.category.toLowerCase() ==
                            selectedCategory.toLowerCase(),
                      )
                          .toList();

                      if (filteredVendors.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                size: 48.sp,
                                color: AppColors.vendorSubtleText,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                l10n.noVendorsFound,
                                style: AppTextStyles.bodyMediumMedium.copyWith(
                                  color: AppColors.vendorSubtleText,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount =
                          (constraints.maxWidth ~/ 130).clamp(2, 5);

                          return GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            itemCount: filteredVendors.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 16.h,
                              childAspectRatio: 0.72,
                            ),
                            itemBuilder: (context, index) {
                              return VendorCardItem(
                                vendor: filteredVendors[index],
                                onTap: () {},
                              );
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.vendorAccent,
                      ),
                    ),
                    error: (err, stack) => VendorsErrorState(
                      message: '${l10n.errorLoadingVendors}: $err',
                      retryLabel: l10n.retryButton,
                      onRetry: () => ref.invalidate(vendorsListProvider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
