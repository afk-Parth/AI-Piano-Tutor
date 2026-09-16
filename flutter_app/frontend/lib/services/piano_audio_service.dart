import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// Centralized audio service for piano playback.
///
/// The UI uses this service through a simple API so the underlying engine can
/// be swapped later without changing the rest of the app.
class PianoAudioService {
  PianoAudioService._();

  static final PianoAudioService instance = PianoAudioService._();

  final int _poolSize = 10;
  final List<AudioPlayer> _players = [];
  final Map<String, Uint8List> _samples = {};
  int _nextPlayer = 0;
  bool _initialized = false;

  /// Initializes the synthesizer and attempts to load a bundled SoundFont.
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    try {
      debugPrint('===== AUDIO INIT START =====');

      // Create player pool
      for (var i = 0; i < _poolSize; i++) {
        final player = AudioPlayer(playerId: 'piano_player_$i');
        try {
          await player.setPlayerMode(PlayerMode.lowLatency);
        } catch (_) {}
        _players.add(player);
      }

      // Load samples from assets/piano/
      final noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
      final octaves = [3, 4];
      var loaded = 0;

      for (final octave in octaves) {
        for (final note in noteNames) {
          final filename = '$note$octave.wav';
          final path = 'assets/piano/$filename';
          try {
            final data = await rootBundle.load(path);
            _samples['$note$octave'] = data.buffer.asUint8List();
            loaded++;
          } catch (e, s) {
            debugPrint('Failed to load $path');
            debugPrint(e.toString());
            debugPrint(s.toString());
          }
        }
      }

      debugPrint('Loaded $loaded piano samples');

      _initialized = true;

      debugPrint('===== AUDIO INIT COMPLETE =====');
    } catch (error, stackTrace) {
      debugPrint('PianoAudioService initialization failed: $error');
      debugPrint(stackTrace.toString());
    }
  }

  /// Plays a note using the UI-friendly note name, for example "C3" or "F#4".
  Future<void> playNote(String noteName) async {
    if (noteName.trim().isEmpty) {
      return;
    }
    try {
      debugPrint('PLAY NOTE -> $noteName');
      await initialize();

      // Parse note and octave
      final normalized = noteName.trim().toUpperCase();
      final match = RegExp(r'^([A-G](?:#|B)?)(-?\d+)$').firstMatch(normalized);
      if (match == null) {
        debugPrint('Unsupported note name: $noteName');
        return;
      }

      final pitchClass = match.group(1)!;
      final octave = int.tryParse(match.group(2)!);
      if (octave == null) {
        debugPrint('Unsupported octave for note: $noteName');
        return;
      }

      final pitchMap = <String, int>{
        'C': 0,
        'C#': 1,
        'DB': 1,
        'D': 2,
        'D#': 3,
        'EB': 3,
        'E': 4,
        'F': 5,
        'F#': 6,
        'GB': 6,
        'G': 7,
        'G#': 8,
        'AB': 8,
        'A': 9,
        'A#': 10,
        'BB': 10,
        'B': 11,
      };

      final semitone = pitchMap[pitchClass];
      if (semitone == null) {
        debugPrint('Unsupported pitch class: $pitchClass');
        return;
      }

      final noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
      final sampleKey = '${noteNames[semitone]}$octave';
      final bytes = _samples[sampleKey];
      if (bytes == null) {
        debugPrint('Sample not found for $sampleKey');
        return;
      }

      debugPrint('Playing $sampleKey');

      if (_players.isEmpty) {
        debugPrint('No audio players available');
        return;
      }

      final player = _players[_nextPlayer];
      _nextPlayer = (_nextPlayer + 1) % _players.length;

      await player.play(BytesSource(bytes));
    } catch (error, stackTrace) {
      debugPrint('PianoAudioService playback failed for $noteName: $error');
      debugPrint(stackTrace.toString());
    }
  }

  Future<void> dispose() async {
    if (!_initialized) {
      return;
    }

    try {
      for (final p in _players) {
        try {
          await p.stop();
          await p.dispose();
        } catch (_) {}
      }
    } catch (error) {
      debugPrint('PianoAudioService dispose failed: $error');
    } finally {
      _initialized = false;
      _samples.clear();
      _players.clear();
      _nextPlayer = 0;
    }
  }

  // legacy: MIDI/SoundFont loader removed in favor of sample-based playback

  int? _noteNameToMidi(String noteName) {
    final normalized = noteName.trim().toUpperCase();
    final match = RegExp(r'^([A-G](?:#|B)?)(-?\d+)$').firstMatch(normalized);
    if (match == null) {
      return null;
    }

    final pitchClass = match.group(1)!;
    final octave = int.tryParse(match.group(2)!);
    if (octave == null) {
      return null;
    }

    final pitchMap = <String, int>{
      'C': 0,
      'C#': 1,
      'DB': 1,
      'D': 2,
      'D#': 3,
      'EB': 3,
      'E': 4,
      'F': 5,
      'F#': 6,
      'GB': 6,
      'G': 7,
      'G#': 8,
      'AB': 8,
      'A': 9,
      'A#': 10,
      'BB': 10,
      'B': 11,
    };

    final semitone = pitchMap[pitchClass];
    if (semitone == null) {
      return null;
    }

    return (octave + 1) * 12 + semitone;
  }
}
