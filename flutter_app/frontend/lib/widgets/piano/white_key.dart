import 'package:ai_piano_tutor/services/piano_audio_service.dart';
import 'package:flutter/material.dart';

import 'piano_widget.dart';

class WhiteKey extends StatefulWidget {
  const WhiteKey({
    super.key,
    required this.keyData,
    required this.isTarget,
    required this.onPressed,
  });

  final PianoKey keyData;
  final bool isTarget;
  final ValueChanged<String> onPressed;

  @override
  State<WhiteKey> createState() => _WhiteKeyState();
}

class _WhiteKeyState extends State<WhiteKey> {
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
    return Expanded(
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
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: widget.isTarget ? Colors.amber : Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
              boxShadow: widget.isTarget || _pressed
                  ? [
                      BoxShadow(
                        color: (widget.isTarget
                                ? Colors.amber
                                : Colors.black)
                            .withValues(alpha: 0.18),
                        blurRadius: _pressed ? 12 : 20,
                        spreadRadius: _pressed ? 2 : 5,
                      ),
                    ]
                  : [],
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(widget.keyData.note),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
