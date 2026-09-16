import 'package:flutter/material.dart';

class ComboCard extends StatelessWidget {
  const ComboCard({
    super.key,
    required this.combo,
  });

  final int combo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasCombo = combo > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: hasCombo
            ? scheme.tertiaryContainer.withValues(alpha: 0.7)
            : scheme.surfaceContainerLow,
        border: Border.all(
          color: hasCombo
              ? scheme.tertiary.withValues(alpha: 0.45)
              : scheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: hasCombo ? scheme.tertiary : scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(
              hasCombo ? Icons.local_fire_department_rounded : Icons.whatshot_rounded,
              color: hasCombo ? scheme.onTertiary : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Combo $combo',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
