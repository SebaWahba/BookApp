import 'package:bookapp/features/home/presentation/vendors/providers/vendor_providers.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';

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

    final categories = [
      (label: l10n.all, value: 'All'),
      (label: l10n.books, value: 'Books'),
      (label: l10n.poems, value: 'Poems'),
      (label: l10n.specialForYou, value: 'Special for you'),
      (label: l10n.stationery, value: 'Stationery'),
    ];

    final selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);
    final vendorsAsync = ref.watch(vendorsListProvider);

    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 1000.0 : double.infinity;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22.sp),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.vendors,
          style: context.type.h4.copyWith(fontSize: 18.sp, color: context.colors.title),
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
                        style: context.type.bodySmallRegular.copyWith(
                          color: context.colors.body,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        l10n.vendors,
                        // Was: AppTextStyles.h5.copyWith(fontSize: 18.sp).
                        // fontSize was already overridden to 18.sp but the
                        // heading still rendered oversized, meaning h5 was
                        // carrying an inflated `height` (line-height) and/or
                        // `letterSpacing`/`fontWeight` that copyWith(fontSize:)
                        // doesn't touch. Pinning those explicitly here makes
                        // this heading's visual size fully deterministic,
                        // independent of whatever h5 does elsewhere.
                        style: context.type.h5.copyWith(
                          color: context.colors.primary,
                          fontSize: 18.sp,
                          height: 1.1,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Bumped from 38.h to 44.h and content wrapped in FittedBox:
                // on tablet, the scaled text+indicator inside was taller than
                // the fixed box, causing bottom overflow. FittedBox makes it
                // shrink-to-fit regardless of scale factor going forward.
                SizedBox(
                  height: 44.h,
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  categories[index].label,
                                  style:
                                  (isSelected
                                      ? context.type.bodyMediumBold
                                      : context.type.bodyMediumMedium)
                                      .copyWith(
                                    color: isSelected
                                        ? context.colors.title
                                        : context.colors.body,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                if (isSelected)
                                  Container(
                                    height: 2.h,
                                    width: 18.w,
                                    decoration: BoxDecoration(
                                      color: context.colors.title,
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                              ],
                            ),
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
                          categories[selectedCategoryIndex].value;
                      final filteredVendors = selectedCategory == 'All'
                          ? vendors
                          : vendors
                          .where(
                            (vendor) =>
                        _categoryKey(vendor.category) ==
                            _categoryKey(selectedCategory),
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
                                color: context.colors.body,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                l10n.noVendorsFound,
                                style: context.type.bodyMediumMedium.copyWith(
                                  color: context.colors.body,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = (constraints.maxWidth ~/ 160)
                              .clamp(2, 5);

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
                              // Lowered from 0.72 to 0.62 to give each
                              // cell more vertical room — fixes bottom
                              // overflow on cards now that the star row
                              // no longer needs the extra horizontal fix
                              // to also eat into vertical space.
                              childAspectRatio: 0.62,
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
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: context.colors.primary,
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

  String _categoryKey(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}