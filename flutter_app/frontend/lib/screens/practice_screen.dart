import 'package:flutter/material.dart';

import '../services/piano_audio_service.dart';
import '../services/microphone_service.dart';
import '../widgets/piano/piano_widget.dart';
import '../widgets/practice/combo_card.dart';
import '../widgets/practice/current_note_card.dart';
import '../widgets/practice/guidance_card.dart';
import '../widgets/practice/progress_card.dart';
import '../widgets/practice/song_header.dart';
import '../widgets/practice/upcoming_notes_card.dart';
import 'session_summary_screen.dart';

class PracticeScreen extends StatefulWidget {
  final Map<String, dynamic> songData;

  const PracticeScreen({
    super.key,
    required this.songData,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int currentIndex = 0;
  int correctNotes = 0;
  int wrongNotes = 0;
  int combo = 0;
  int maxCombo = 0;

  late List<String> notes;
  late List<String> guidance;

  DateTime? sessionStart;

  /// false = virtual piano
  /// true = microphone mode
  bool microphoneMode = false;

  final MicrophoneService microphone = MicrophoneService();

  @override
  void initState() {
    super.initState();

    notes = List<String>.from(widget.songData['notes'] ?? []);
    guidance = List<String>.from(widget.songData['guidance'] ?? []);

    sessionStart = DateTime.now();

    microphone.onNoteDetected = (note) {
      if (!mounted) return;
      if (!microphoneMode) return;

      onKeyPressed(note);
    };
  }
    Future<void> onKeyPressed(String key) async {
    final currentNote = currentNoteText;

    // Play piano sound only in virtual mode
    if (!microphoneMode) {
      await PianoAudioService.instance.playNote(key);
    }

    if (key == currentNote) {
      if (currentIndex == notes.length - 1) {
        setState(() {
          correctNotes++;
          combo++;

          if (combo > maxCombo) {
            maxCombo = combo;
          }
        });

        if (microphoneMode) {
          await microphone.stopListening();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SessionSummaryScreen(
              songData: widget.songData,
              correctNotes: correctNotes,
              wrongNotes: wrongNotes,
              accuracy: accuracy,
              duration: sessionDuration,
            ),
          ),
        );

        return;
      }

      setState(() {
        correctNotes++;
        combo++;

        if (combo > maxCombo) {
          maxCombo = combo;
        }

        currentIndex++;
      });

      return;
    }

    setState(() {
      wrongNotes++;
      combo = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 500),
        content: Text("Wrong Note"),
      ),
    );
  }

  Future<void> toggleMicrophoneMode() async {
    setState(() {
      microphoneMode = !microphoneMode;
    });

    if (microphoneMode) {
      await microphone.startListening();
    } else {
      await microphone.stopListening();
    }
  }

  double get accuracy {
    final total = correctNotes + wrongNotes;

    if (total == 0) return 0;

    return (correctNotes / total) * 100;
  }

  String get sessionDuration {
    if (sessionStart == null) {
      return '0s';
    }

    final seconds = DateTime.now().difference(sessionStart!).inSeconds;

    return '${seconds}s';
  }

  String get currentGuidance {
    if (guidance.isEmpty) {
      return '🎹 Play the highlighted note';
    }

    if (currentIndex >= guidance.length) {
      return '';
    }

    return guidance[currentIndex];
  }

  String get currentNoteText {
    if (notes.isEmpty) {
      return '';
    }

    return notes[currentIndex];
  }

  double get progress {
    if (notes.isEmpty) {
      return 0;
    }

    return (currentIndex + 1) / notes.length;
  }

  @override
  void dispose() {
    microphone.stopListening();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.songData['title']),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.surface,
              scheme.surfaceContainerHighest.withValues(alpha: 0.35),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SongHeader(
                        title: widget.songData['title'],
                        difficulty: widget.songData['difficulty'],
                        duration: widget.songData['duration'],
                        imagePath: widget.songData['image'],
                      ),

                      const SizedBox(height: 14),

                      ProgressCard(
                        progress: progress,
                        currentIndex: currentIndex,
                        totalNotes: notes.length,
                      ),

                      const SizedBox(height: 12),

                      GuidanceCard(
                        text: currentGuidance,
                      ),

                      const SizedBox(height: 12),

                      UpcomingNotesCard(
                        notes: notes,
                        currentIndex: currentIndex,
                      ),

                      const SizedBox(height: 12),

                      CurrentNoteCard(
                        currentNote: currentNoteText,
                      ),

                      const SizedBox(height: 12),

                      ComboCard(
                        combo: combo,
                      ),

                      const SizedBox(height: 20),

                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                microphoneMode
                                    ? Icons.mic
                                    : Icons.piano,
                                size: 34,
                                color: microphoneMode
                                    ? Colors.green
                                    : Colors.blue,
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      microphoneMode
                                          ? "Microphone Mode"
                                          : "Virtual Piano Mode",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      microphoneMode
                                          ? "Play your real piano"
                                          : "Tap the virtual keyboard",
                                    ),
                                  ],
                                ),
                              ),

                              Switch(
                                value: microphoneMode,
                                onChanged: (_) {
                                  toggleMicrophoneMode();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!microphoneMode)
                        PianoWidget(
                          currentNote: currentNoteText,
                          onKeyPressed: onKeyPressed,
                        ),

                      if (microphoneMode)
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.mic,
                                size: 80,
                                color: Colors.green,
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "Listening for Piano...",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Play: $currentNoteText",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "The app will automatically detect your piano note.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}