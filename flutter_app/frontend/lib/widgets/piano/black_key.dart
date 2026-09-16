import 'package:ai_piano_tutor/services/piano_audio_service.dart';
import 'package:flutter/material.dart';

import 'piano_widget.dart';

class BlackKey extends StatefulWidget {
  const BlackKey({
    super.key,
    required this.keyData,
    required this.left,
    required this.isTarget,
    required this.onPressed,
  });

  final PianoKey keyData;
  final double left;
  final bool isTarget;
  final ValueChanged<String> onPressed;

  @override
  State<BlackKey> createState() => _BlackKeyState();
}

class _BlackKeyState extends State<BlackKey> {
  bool _pressed = false;

  void _handleRelease() {
    if (!mounted) {
      return;
    }
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapUp: (_) => _handleRelease(),
        onTapCancel: _handleRelease,
        onTap: () async {
          debugPrint('UI pressed key: ${widget.keyData.note}');
          await PianoAudioService.instance.playNote(widget.keyData.note);
          widget.onPressed(widget.keyData.note);
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 130),
          scale: _pressed ? 0.97 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 130),
            width: 28,
            height: 150,
            decoration: BoxDecoration(
              color: widget.isTarget ? Colors.amber : Colors.black,
              borderRadius: BorderRadius.circular(6),
              boxShadow: widget.isTarget || _pressed
                  ? [
                      BoxShadow(
                        color: (widget.isTarget
                                ? Colors.amber
                                : Colors.white)
                            .withValues(alpha: 0.18),
                        blurRadius: _pressed ? 12 : 20,
                        spreadRadius: _pressed ? 2 : 5,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}
