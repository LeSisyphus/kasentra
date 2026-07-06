import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';

class DebtTypeSegmentedControl extends StatelessWidget {
  const DebtTypeSegmentedControl({
    super.key,
    required this.isReceivable,
    required this.onChanged,
  });

  final bool isReceivable;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: KasentraColors.surfaceWarm,
        borderRadius: BorderRadius.circular(KasentraRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DebtTypeOption(
              label: 'Piutang Pelanggan',
              selected: isReceivable,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _DebtTypeOption(
              label: 'Utang Saya',
              selected: !isReceivable,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtTypeOption extends StatelessWidget {
  const _DebtTypeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? KasentraColors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(KasentraRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KasentraRadius.md),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: selected
                  ? KasentraColors.primaryDark
                  : KasentraColors.textPrimary,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
