import json
import librosa
import numpy as np
import sounddevice as sd
from pathlib import Path

CALIBRATION_NOTES = [
    "C3", "D3", "E3", "F3",
    "G3", "A3", "B3", "C4"
]

NOTE_NAMES = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
]


def frequency_to_note(freq):
    """Convert frequency to piano note."""

    if freq <= 0:
        return None

    midi = round(69 + 12 * np.log2(freq / 440.0))

    note = NOTE_NAMES[midi % 12]
    octave = (midi // 12) - 1

    return f"{note}{octave}"


def detect_frequency(duration=2, sample_rate=44100):
    """Record audio and return detected frequency."""

    print("Recording...")

    audio = sd.rec(
        int(duration * sample_rate),
        samplerate=sample_rate,
        channels=1,
        dtype='float32'
    )

    sd.wait()

    audio = audio.flatten()

    pitches = librosa.yin(
        audio,
        fmin=50,
        fmax=2000,
        sr=sample_rate
    )

    pitches = pitches[~np.isnan(pitches)]

    if len(pitches) == 0:
        return None

    frequency = np.median(pitches)

    return frequency


def save_calibration(data):
    """Save calibration profile."""

    path = Path("backend/calibration/calibration.json")

    with open(path, "w") as f:
        json.dump(data, f, indent=4)


def main():

    print("\n=== Piano Calibration Wizard ===")
    print("\nPlay each note 3 times.")
    print("Use the octave that works best on your keyboard.\n")

    calibration_data = {}

    for note in CALIBRATION_NOTES:

        print(f"\n--- Calibrating {note} ---")

        frequencies = []

        attempt = 1

        while len(frequencies) < 3:

            input(
                f"\nPress Enter, then play {note} "
                f"({attempt}/3)..."
            )

            frequency = detect_frequency()

            if frequency is None:

                print("No note detected. Try again.")

                continue

            detected_note = frequency_to_note(frequency)

            print(
                f"Detected: {frequency:.2f} Hz "
                f"({detected_note})"
            )

            frequencies.append(frequency)

            attempt += 1

        median_frequency = float(np.median(frequencies))

        calibration_data[note] = median_frequency

        print(
            f"\nSaved {note}: "
            f"{median_frequency:.2f} Hz"
        )

    save_calibration(calibration_data)

    print("\nCalibration complete!")

    print("\nCalibration profile:")

    for note, freq in calibration_data.items():

        print(f"{note}: {freq:.2f} Hz")

    print(
        "\nSaved to "
        "backend/calibration/calibration.json"
    )


if __name__ == "__main__":
    main()