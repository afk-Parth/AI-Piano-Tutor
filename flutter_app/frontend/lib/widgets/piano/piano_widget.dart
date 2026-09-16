import 'package:flutter/material.dart';

import 'black_key.dart';
import 'white_key.dart';

class PianoKey {
  final String note;
  final bool isBlack;

  const PianoKey({
    required this.note,
    required this.isBlack,
  });
}

class PianoWidget extends StatelessWidget {
  const PianoWidget({
    super.key,
    required this.currentNote,
    required this.onKeyPressed,
  });

  final String currentNote;
  final ValueChanged<String> onKeyPressed;

  static const List<PianoKey> pianoKeys = [
    PianoKey(note: 'C3', isBlack: false),
    PianoKey(note: 'C#3', isBlack: true),
    PianoKey(note: 'D3', isBlack: false),
    PianoKey(note: 'D#3', isBlack: true),
    PianoKey(note: 'E3', isBlack: false),
    PianoKey(note: 'F3', isBlack: false),
    PianoKey(note: 'F#3', isBlack: true),
    PianoKey(note: 'G3', isBlack: false),
    PianoKey(note: 'G#3', isBlack: true),
    PianoKey(note: 'A3', isBlack: false),
    PianoKey(note: 'A#3', isBlack: true),
    PianoKey(note: 'B3', isBlack: false),
    PianoKey(note: 'C4', isBlack: false),
    PianoKey(note: 'C#4', isBlack: true),
    PianoKey(note: 'D4', isBlack: false),
    PianoKey(note: 'D#4', isBlack: true),
    PianoKey(note: 'E4', isBlack: false),
    PianoKey(note: 'F4', isBlack: false),
    PianoKey(note: 'F#4', isBlack: true),
    PianoKey(note: 'G4', isBlack: false),
    PianoKey(note: 'G#4', isBlack: true),
    PianoKey(note: 'A4', isBlack: false),
    PianoKey(note: 'A#4', isBlack: true),
    PianoKey(note: 'B4', isBlack: false),
  ];

  static List<PianoKey> get whiteKeys =>
      pianoKeys.where((key) => !key.isBlack).toList();

  static List<PianoKey> get blackKeys =>
      pianoKeys.where((key) => key.isBlack).toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Row(
            children: whiteKeys.map((key) {
              return WhiteKey(
                keyData: key,
                isTarget: key.note == currentNote,
                onPressed: onKeyPressed,
              );
            }).toList(),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final whiteWidth = constraints.maxWidth / whiteKeys.length;
              return Stack(
                children: [
                  BlackKey(
                    keyData: blackKeys[0],
                    left: whiteWidth * 0.75,
                    isTarget: blackKeys[0].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[1],
                    left: whiteWidth * 1.75,
                    isTarget: blackKeys[1].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[2],
                    left: whiteWidth * 3.75,
                    isTarget: blackKeys[2].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[3],
                    left: whiteWidth * 4.75,
                    isTarget: blackKeys[3].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[4],
                    left: whiteWidth * 5.75,
                    isTarget: blackKeys[4].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[5],
                    left: whiteWidth * 7.75,
                    isTarget: blackKeys[5].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[6],
                    left: whiteWidth * 8.75,
                    isTarget: blackKeys[6].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[7],
                    left: whiteWidth * 10.75,
                    isTarget: blackKeys[7].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[8],
                    left: whiteWidth * 11.75,
                    isTarget: blackKeys[8].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                  BlackKey(
                    keyData: blackKeys[9],
                    left: whiteWidth * 12.75,
                    isTarget: blackKeys[9].note == currentNote,
                    onPressed: onKeyPressed,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
