import 'package:flutter/material.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

   @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}