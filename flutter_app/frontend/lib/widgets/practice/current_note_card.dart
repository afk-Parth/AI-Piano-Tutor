import 'package:ai_piano_tutor/services/piano_audio_service.dart';
import 'package:flutter/material.dart';

class CurrentNoteCard extends StatelessWidget {
  const CurrentNoteCard({
    super.key,
    required this.currentNote,
  });

  final String currentNote;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            scheme.secondaryContainer,
            scheme.tertiaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.secondary.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Tooltip(
                message: 'Hear Note',
                child: IconButton.filledTonal(
                  onPressed: () {
                    PianoAudioService.instance.playNote(currentNote);
                  },
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Hear Note',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.piano,
                color: scheme.onSecondaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Current Note',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              key: ValueKey<String>(currentNote),
              currentNote,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSecondaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
