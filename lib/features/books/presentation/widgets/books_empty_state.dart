import 'package:flutter/material.dart';

import '../../../../core/theme/extensions/theme_ext.dart';

class BooksEmptyState extends StatelessWidget {
  const BooksEmptyState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.65,
          child: Center(
            child: Text(
              message,
              style: context.type.bodyMediumRegular.copyWith(
                color: context.colors.body,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
