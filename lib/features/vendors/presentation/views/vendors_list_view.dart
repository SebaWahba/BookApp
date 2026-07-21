import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/vendors/presentation/providers/vendor_providers.dart';
import '../widgets/vendor_card_item.dart';

class VendorsListView extends ConsumerStatefulWidget {
  const VendorsListView({super.key});

  @override
  ConsumerState<VendorsListView> createState() => _VendorsListViewState();
}

class _VendorsListViewState extends ConsumerState<VendorsListView> {
  final List<String> categories = ['All', 'Books', 'Poems', 'Special for you', 'Stationery'];

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Vendors', // ✅ Fixed Typo
          style: TextStyle(
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
              // Our Vendors Header
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Vendors',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Vendors', // ✅ Fixed Typo
                      style: TextStyle(
                        color: Color(0xFF6F43C0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal Category Selector
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
                        ref.read(selectedCategoryIndexProvider.notifier).state = index;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              categories[index],
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF222222) : const Color(0xFF9E9E9E),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (isSelected)
                              Container(
                                height: 2,
                                width: 18,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF222222),
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

              // 3-Columns Grid View with Riverpod AsyncValue
              Expanded(
                child: vendorsAsync.when(
                  data: (vendors) {
                    final selectedCategory = categories[selectedCategoryIndex];
                    final filteredVendors = selectedCategory == 'All'
                        ? vendors
                        : vendors
                            .where((v) => v.category.toLowerCase() == selectedCategory.toLowerCase())
                            .toList();

                    if (filteredVendors.isEmpty) {
                      return const Center(
                        child: Text(
                          'No vendors found',
                          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredVendors.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    child: CircularProgressIndicator(color: Color(0xFF6F43C0)),
                  ),
                  error: (err, stack) => Center(
                    child: Text('Error: $err'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}