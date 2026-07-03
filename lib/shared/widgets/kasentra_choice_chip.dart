import 'package:flutter/material.dart';

import '../../app/theme/kasentra_colors.dart';
import '../../app/theme/kasentra_radius.dart';

class KasentraChoiceChip extends StatelessWidget {
  const KasentraChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      backgroundColor: KasentraColors.surface,
      selectedColor: KasentraColors.primarySoft,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: selected
            ? KasentraColors.primaryDark
            : KasentraColors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: selected ? KasentraColors.primary : KasentraColors.borderLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KasentraRadius.chip),
      ),
    );
  }
}
