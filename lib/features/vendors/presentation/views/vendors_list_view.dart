import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import '../../../../config/themes/app_colors.dart';
import 'package:bookapp/features/vendors/presentation/providers/vendor_providers.dart';
import '../widgets/vendor_card_item.dart';

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

    // Page-level decision (does the whole screen's shape change?) -> MediaQuery.
    final isTablet =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 700.0 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.vendors,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black, size: 24.sp),
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
                        style: TextStyle(
                          color: AppColors.vendorSubtleText,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        l10n.vendors,
                        style: TextStyle(
                          color: AppColors.vendorAccent,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
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
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.vendorTitleText
                                      : AppColors.vendorSubtleText,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
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
                                style: TextStyle(
                                  color: AppColors.vendorSubtleText,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Widget-level decision (how much space did THIS
                      // grid actually get?) -> LayoutBuilder.
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
                    error: (err, stack) => Center(
                      child: Text('${l10n.errorLoadingVendors}: $err'),
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