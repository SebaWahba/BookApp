import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/l10n/app_localizations.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.vendors,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ourVendors,
                      style: const TextStyle(
                        color: AppColors.vendorSubtleText,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.vendors,
                      style: const TextStyle(
                        color: AppColors.vendorAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedCategoryIndex;
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(selectedCategoryIndexProvider.notifier)
                            .selectCategory(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
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
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isSelected)
                              Container(
                                height: 2,
                                width: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.vendorTitleText,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: vendorsAsync.when(
                  data: (vendors) {
                    final selectedCategory = categories[selectedCategoryIndex];
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
                            const Icon(
                              Icons.storefront_outlined,
                              size: 48,
                              color: AppColors.vendorSubtleText,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.noVendorsFound,
                              style: const TextStyle(
                                color: AppColors.vendorSubtleText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: filteredVendors.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
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
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.vendorAccent,
                    ),
                  ),
                  error: (err, stack) =>
                      Center(child: Text('${l10n.errorLoadingVendors}: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
