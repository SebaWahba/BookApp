import 'package:flutter/material.dart';

class SearchBooksGrid extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const SearchBooksGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 127 / 190,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
