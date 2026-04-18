import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_entity.dart';

final selectedCategoryProvider =
    StateProvider<ProductCategory?>((ref) => null);

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          _chip(context, ref, null, 'Todos', selected),
          ...ProductCategory.values
              .map((c) => _chip(context, ref, c, c.label, selected)),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, WidgetRef ref,
      ProductCategory? value, String label, ProductCategory? selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected == value,
        onSelected: (_) =>
            ref.read(selectedCategoryProvider.notifier).state = value,
        selectedColor: const Color(0x338B4513),
        checkmarkColor: const Color(0xFF8B4513),
      ),
    );
  }
}
