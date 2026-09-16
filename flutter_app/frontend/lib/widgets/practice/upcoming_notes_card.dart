import 'package:flutter/material.dart';

class UpcomingNotesCard extends StatelessWidget {
  const UpcomingNotesCard({
    super.key,
    required this.notes,
    required this.currentIndex,
  });

  final List<String> notes;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final upcomingNotes = <String>[];

    for (int i = currentIndex + 1;
        i < notes.length && upcomingNotes.length < 4;
        i++) {
      upcomingNotes.add(notes[i]);
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surfaceContainerLow,
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.queue_music_rounded,
                size: 18,
                color: scheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Upcoming Notes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (upcomingNotes.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'No more notes',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: upcomingNotes
                  .asMap()
                  .entries
                  .map(
                    (entry) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: entry.key == 0
                            ? scheme.primaryContainer
                            : scheme.surfaceContainerHighest,
                      ),
                      child: Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: entry.key == 0
                                  ? scheme.onPrimaryContainer
                                  : scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
