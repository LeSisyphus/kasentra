import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_radius.dart';

class PaymentStatusSelector extends StatelessWidget {
  const PaymentStatusSelector({
    super.key,
    required this.isPaid,
    required this.onChanged,
  });

  final bool isPaid;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: KasentraColors.surfaceWarm,
        borderRadius: BorderRadius.circular(KasentraRadius.input),
        border: Border.all(color: KasentraColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PaymentOption(
              label: 'Lunas',
              selected: isPaid,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _PaymentOption(
              label: 'Belum Lunas',
              selected: !isPaid,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
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
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
