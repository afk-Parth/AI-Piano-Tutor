import librosa
import numpy as np
import os

NOTE_NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F',
              'F#', 'G', 'G#', 'A', 'A#', 'B']


def frequency_to_note(freq):
    if freq <= 0:
        return "Unknown"

    midi = round(69 + 12 * np.log2(freq / 440.0))

    note = NOTE_NAMES[midi % 12]
    octave = (midi // 12) - 1

    return f"{note}{octave}"


def detect_note(audio_path):
    y, sr = librosa.load(audio_path, sr=None)

    pitches = librosa.yin(
        y,
        fmin=50,
        fmax=2000,
        sr=sr
    )

    pitches = pitches[~np.isnan(pitches)]

    if len(pitches) == 0:
        return None, None

    freq = np.median(pitches)

    note = frequency_to_note(freq)

    return freq, note


if __name__ == "__main__":
    path = input("Enter path to WAV file: ")

    freq, note = detect_note(path)

    if freq is None:
        print("Could not detect a note.")
    else:
        print(f"Detected Frequency: {freq:.2f} Hz")
        print(f"Predicted Note: {note}")