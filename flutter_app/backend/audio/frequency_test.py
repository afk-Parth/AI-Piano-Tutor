import sounddevice as sd
import librosa
import numpy as np

NOTE_NAMES = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
]


def frequency_to_note(freq):
    if freq <= 0:
        return None

    midi = round(69 + 12 * np.log2(freq / 440.0))

    note = NOTE_NAMES[midi % 12]
    octave = (midi // 12) - 1

    return f"{note}{octave}"


def detect_frequency(audio, sr):

    pitches = librosa.yin(
        audio,
        fmin=50,
        fmax=2000,
        sr=sr
    )

    pitches = pitches[~np.isnan(pitches)]

    if len(pitches) == 0:
        return None, None

    frequency = np.median(pitches)

    note = frequency_to_note(frequency)

    return frequency, note


sample_rate = 44100
duration = 2

print("\n=== Frequency Stability Test ===")

while True:

    input("\nPress Enter, then play ONE piano key...")

    print("Recording...")

    audio = sd.rec(
        int(duration * sample_rate),
        samplerate=sample_rate,
        channels=1,
        dtype='float32'
    )

    sd.wait()

    audio = audio.flatten()

    frequency, note = detect_frequency(audio, sample_rate)

    if frequency is None:

        print("No note detected.")

    else:

        print(f"Frequency: {frequency:.2f} Hz")
        print(f"Predicted Note: {note}")