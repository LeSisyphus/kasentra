import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';

class ExpenseCategoryChip extends StatelessWidget {
  const ExpenseCategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: KasentraColors.primary,
      backgroundColor: KasentraColors.surfaceWarm,
      side: BorderSide(
        color: selected ? KasentraColors.primary : KasentraColors.borderLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KasentraRadius.chip),
      ),
      labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: selected ? Colors.white : KasentraColors.textPrimary,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
